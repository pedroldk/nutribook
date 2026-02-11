class Service < ApplicationRecord
  belongs_to :nutritionist
  has_many :appointments

  # Tell Geocoder to look at the 'location' column in the Services table
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
