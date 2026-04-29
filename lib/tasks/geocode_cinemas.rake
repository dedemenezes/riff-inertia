desc "Geocode cinemas using Mapbox Geocoding API"
task geocode_cinemas: :environment do
  token = ENV.fetch("MAPBOX_ACCESS_TOKEN")
  base_url = "https://api.mapbox.com/search/geocode/v6/forward"

  # Rio de Janeiro metropolitan area bounding box
  rio_bbox = "-43.8,-23.1,-42.8,-22.7"
  rio_proximity = "-43.1729,-22.9068"

  cinemas = Cinema.where(latitude: nil).or(Cinema.where(longitude: nil))
                  .where.not(endereco: [nil, ""])

  puts "Found #{cinemas.count} cinemas to geocode"

  cinemas.find_each do |cinema|
    query = "#{cinema.endereco}, Rio de Janeiro, RJ, Brazil"
    params = URI.encode_www_form(
      q: query,
      access_token: token,
      limit: 1,
      country: "BR",
      proximity: rio_proximity,
      bbox: rio_bbox
    )
    url = URI("#{base_url}?#{params}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    feature = data.dig("features", 0)
    unless feature
      puts "  [SKIP] #{cinema.nome} — no results for '#{cinema.endereco}'"
      next
    end

    lng, lat = feature.dig("geometry", "coordinates")
    cinema.update!(latitude: lat, longitude: lng)
    puts "  [OK] #{cinema.nome} → #{lat}, #{lng}"

    sleep 0.2 # rate limit courtesy
  end

  puts "Done!"
end
