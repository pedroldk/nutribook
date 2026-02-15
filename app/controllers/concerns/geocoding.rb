module Geocoding
  def geocode_param(location_param)
    # Accept "lat,lon" input; otherwise map known place names; default to Braga
    braga = [ 41.5454, -8.4265 ]
    return braga unless location_param.present?

    if location_param =~ /(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)/
      [ $1.to_f, $2.to_f ]
    else
      # Look up coordinates from existing geocoded services in the database
      match = Service.where("location ILIKE ?", "%#{location_param.strip}%")
                     .where.not(latitude: nil, longitude: nil)
                     .first
      if match
        [ match.latitude, match.longitude ]
      else
        braga
      end
    end
  end

  def nearest_service_and_distance(nutritionist, lat, lon)
    services = nutritionist.services.select { |s| s.latitude && s.longitude }
    return [ nil, nil ] if services.empty?

    best = services.map do |s|
      d = haversine_distance_km(lat, lon, s.latitude, s.longitude)
      [ s, d ]
    end.min_by { |pair| pair[1] }

    best
  end

  def haversine_distance_km(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    rkm = 6371 # Earth radius in kilometers
    dlat_rad = (lat2 - lat1) * rad_per_deg
    dlon_rad = (lon2 - lon1) * rad_per_deg

    lat1_rad, lat2_rad = lat1 * rad_per_deg, lat2 * rad_per_deg

    a = Math.sin(dlat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    rkm * c
  end
end
