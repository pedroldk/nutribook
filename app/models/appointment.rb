class Appointment < ApplicationRecord
  belongs_to :service
  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  # Return the JSON shape used by the API controllers / clients.
  # Keeps serialization in one place so controllers can stay thin.
  def as_api_json
    {
      id: id,
      guest_name: guest_name,
      guest_email: guest_email,
      start_time: start_time,
      status: status,
      service: {
        id: service.id,
        name: service.name,
        location: service.location
      }
    }
  end
end
