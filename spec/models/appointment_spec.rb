require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'associations' do
    it 'belongs to a service' do
      appointment = FactoryBot.create(:appointment)
      expect(appointment.service).to be_present
    end
  end

  describe 'status enum' do
    let(:service) { FactoryBot.create(:service) }

    it 'supports pending, accepted, and rejected statuses' do
      appointment = FactoryBot.create(:appointment, service: service, status: :pending)

      expect(appointment).to be_pending

      appointment.accepted!
      expect(appointment.reload).to be_accepted

      appointment.rejected!
      expect(appointment.reload).to be_rejected
    end

    it 'defaults new appointments to pending when created with status: :pending' do
      appointment = Appointment.create!(
        guest_name: "Test",
        guest_email: "test@example.com",
        start_time: 1.day.from_now,
        service: service,
        status: :pending
      )
      expect(appointment.status).to eq("pending")
    end
  end

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
