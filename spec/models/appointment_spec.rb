require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe '#as_api_json' do
    it 'returns the expected JSON shape including nested service' do
      service = FactoryBot.build_stubbed(:service, name: 'Consult', location: 'Lisbon')
      appointment = FactoryBot.build_stubbed(:appointment, guest_name: 'Max', guest_email: 'm@example.com', start_time: '2026-02-10 10:00', status: :pending, service: service)

      json = appointment.as_api_json

      expect(json).to include(
        id: appointment.id,
        guest_name: 'Max',
        guest_email: 'm@example.com',
        start_time: appointment.start_time,
        status: 'pending'
      )

      expect(json[:service]).to include(
        id: service.id,
        name: 'Consult',
        location: 'Lisbon'
      )
    end
  end
end
