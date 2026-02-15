require 'rails_helper'

RSpec.describe "Nutritionists", type: :request do
  describe "GET /nutritionists (HTML)" do
    it "returns http success" do
      get "/nutritionists"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /nutritionists.json" do
    let!(:ana) do
      n = FactoryBot.create(:nutritionist, name: "Ana Silva", email: "ana@test.com")
      s = n.services.build(name: "General Consultation", price: 30, location: "Braga, Portugal")
      s.save!(validate: false)
      s.update_columns(latitude: 41.5454, longitude: -8.4265)
      n
    end

    let!(:joao) do
      n = FactoryBot.create(:nutritionist, name: "João Pereira", email: "joao@test.com")
      s = n.services.build(name: "Sports Nutrition", price: 50, location: "Porto, Portugal")
      s.save!(validate: false)
      s.update_columns(latitude: 41.1496, longitude: -8.611)
      n
    end

    let!(:maria) do
      n = FactoryBot.create(:nutritionist, name: "Maria Costa", email: "maria@test.com")
      s = n.services.build(name: "Pediatric Nutrition", price: 60, location: "Lisbon, Portugal")
      s.save!(validate: false)
      s.update_columns(latitude: 38.7223, longitude: -9.1393)
      n
    end

    it "returns all nutritionists when no params are given" do
      get "/nutritionists.json"
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body.length).to eq(3)
    end

    context "search by nutritionist name" do
      it "returns only the matching nutritionist" do
        get "/nutritionists.json", params: { q: "Ana" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
        expect(body.first["name"]).to eq("Ana Silva")
      end

      it "is case-insensitive" do
        get "/nutritionists.json", params: { q: "ana" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
        expect(body.first["name"]).to eq("Ana Silva")
      end

      it "returns empty when no name matches" do
        get "/nutritionists.json", params: { q: "Nonexistent" }
        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context "search by service name" do
      it "returns the nutritionist offering the matching service" do
        get "/nutritionists.json", params: { q: "Sports" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
        expect(body.first["name"]).to eq("João Pereira")
        expect(body.first["service"]["name"]).to eq("Sports Nutrition")
      end

      it "matches partial service names" do
        get "/nutritionists.json", params: { q: "Consultation" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
        expect(body.first["name"]).to eq("Ana Silva")
      end
    end

    context "search by location" do
      it "orders results by distance to the given location" do
        get "/nutritionists.json", params: { location: "Porto" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(3)
        # João is in Porto, so should be first (closest)
        expect(body.first["name"]).to eq("João Pereira")
        expect(body.first["distance_km"]).to be < 1
      end

      it "accepts lat,lon coordinates" do
        # Lisbon coordinates
        get "/nutritionists.json", params: { location: "38.7223,-9.1393" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(3)
        # Maria is in Lisbon, so should be first
        expect(body.first["name"]).to eq("Maria Costa")
        expect(body.first["distance_km"]).to be < 1
      end

      it "defaults to Braga when location is not recognized" do
        get "/nutritionists.json", params: { location: "UnknownCity12345" }
        body = JSON.parse(response.body)
        expect(body.length).to eq(3)
        # Ana is in Braga, so should be first
        expect(body.first["name"]).to eq("Ana Silva")
        expect(body.first["distance_km"]).to be < 1
      end
    end

    context "combined search" do
      it "filters by name AND orders by location" do
        get "/nutritionists.json", params: { q: "Nutrition", location: "38.7223,-9.1393" }
        body = JSON.parse(response.body)
        # Both João (Sports Nutrition) and Maria (Pediatric Nutrition) match
        names = body.map { |r| r["name"] }
        expect(names).to include("João Pereira", "Maria Costa")
        # Maria (Lisbon) should come first since location is Lisbon
        expect(body.first["name"]).to eq("Maria Costa")
      end
    end
  end
end
