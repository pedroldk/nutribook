class NutritionistsController < ApplicationController
  include Geocoding

  # Simple search endpoint: responds to HTML and JSON.
  # JSON response returns nutritionists ordered by distance to the provided location.
  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        q = params[:q].presence
        lat, lon = geocode_param(params[:location])

        # base scope
        scope = Nutritionist.all

        if q
          scope = scope.joins(:services).where("services.name ILIKE :q OR nutritionists.name ILIKE :q", q: "%#{q}%").distinct
        end

        results = scope.includes(:services).map do |n|
          nearest_service, distance_km = nearest_service_and_distance(n, lat, lon)
          next unless nearest_service

          {
            id: n.id,
            name: n.name,
            email: n.email,
            distance_km: distance_km.round(2),
            service: {
              id: nearest_service.id,
              name: nearest_service.name,
              location: nearest_service.location,
              latitude: nearest_service.latitude,
              longitude: nearest_service.longitude,
              price: nearest_service.price
            }
          }
        end.compact

        # order by distance
        results.sort_by! { |r| r[:distance_km] }

        render json: results
      end
    end
  end
end
