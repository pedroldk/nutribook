# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding nutritionists and services..."

nutritionists = [
  { name: "Ana Silva", email: "ana@sample.test" },
  { name: "João Pereira", email: "joao@sample.test" },
  { name: "Maria Costa", email: "maria@sample.test" },
  { name: "Rui Santos", email: "rui@sample.test" },
  { name: "Inês Alves", email: "ines@sample.test" }
]

nutritionists.each do |attrs|
  n = Nutritionist.find_or_initialize_by(email: attrs[:email])
  n.name = attrs[:name]
  n.save!

  # Create a few services for each nutritionist with varying prices & locations
  case attrs[:email]
  when "ana@sample.test"
    s = n.services.find_or_initialize_by(name: "General Consultation")
    s.price = 30.0
    s.location = "Braga, Portugal"
    s.save!
    # set coordinates directly to avoid external geocoding during seeds
    s.update_columns(latitude: 41.5454, longitude: -8.4265) if s.latitude.blank? || s.longitude.blank?

    s2 = n.services.find_or_initialize_by(name: "Weight Loss Program")
    s2.price = 120.0
    s2.location = "Braga, Portugal"
    s2.save!
    s2.update_columns(latitude: 41.5454, longitude: -8.4265) if s2.latitude.blank? || s2.longitude.blank?
  when "joao@sample.test"
    s = n.services.find_or_initialize_by(name: "Sports Nutrition")
    s.price = 50.5
    s.location = "Porto, Portugal"
    s.save!
    s.update_columns(latitude: 41.1496, longitude: -8.611) if s.latitude.blank? || s.longitude.blank?

    s2 = n.services.find_or_initialize_by(name: "Online Consultation")
    s2.price = 25.0
    s2.location = "Online"
    s2.save!
  when "maria@sample.test"
    s = n.services.find_or_initialize_by(name: "Pediatric Nutrition")
    s.price = 60.0
    s.location = "Lisbon, Portugal"
    s.save!
    s.update_columns(latitude: 38.7223, longitude: -9.1393) if s.latitude.blank? || s.longitude.blank?
  when "rui@sample.test"
    s = n.services.find_or_initialize_by(name: "Diabetes Management")
    s.price = 45.0
    s.location = "Coimbra, Portugal"
    s.save!
    s.update_columns(latitude: 40.2033, longitude: -8.4103) if s.latitude.blank? || s.longitude.blank?
  when "ines@sample.test"
    s = n.services.find_or_initialize_by(name: "Eating Disorders Support")
    s.price = 80.0
    s.location = "Viana do Castelo, Portugal"
    s.save!
    s.update_columns(latitude: 41.6914, longitude: -8.832) if s.latitude.blank? || s.longitude.blank?
  end
end

puts "Seeding complete. Created #{Nutritionist.count} nutritionists and #{Service.count} services."

puts <<~INFO
To load seeds locally:
	bin/rails db:seed

Example search requests you can use to test the JSON endpoint:
	# search by service name near Braga
	curl 'http://localhost:3000/nutritionists.json?q=consultation&location=braga'

	# search by location coordinates
	curl 'http://localhost:3000/nutritionists.json?location=41.5454,-8.4265'
INFO
