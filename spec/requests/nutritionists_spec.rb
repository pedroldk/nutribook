require 'rails_helper'

RSpec.describe "Nutritionists", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/nutritionists/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/nutritionists/show"
      expect(response).to have_http_status(:success)
    end
  end

end
