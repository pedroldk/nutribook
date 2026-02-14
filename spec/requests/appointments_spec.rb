require 'rails_helper'

RSpec.describe "Appointments (public)", type: :request do
  describe 'POST /appointments' do
    let(:service) { FactoryBot.create(:service) }

    it 'creates a pending appointment and returns 201' do
      post '/appointments', params: { appointment: { guest_name: 'Alex', guest_email: 'a@example.com', start_time: '2026-02-20T10:00', service_id: service.id } }
      expect(response).to have_http_status(:created)

      appt = Appointment.last
      expect(appt.guest_email).to eq('a@example.com')
      expect(appt.status).to eq('pending')
    end

    it 'rejects any previous pending requests from same guest email' do
      old = FactoryBot.create(:appointment, guest_email: 'same@example.com', status: :pending, service: service)

      post '/appointments', params: { appointment: { guest_name: 'New', guest_email: 'same@example.com', start_time: '2026-02-21T11:00', service_id: service.id } }
      expect(response).to have_http_status(:created)

      expect(old.reload.status).to eq('rejected')
      expect(Appointment.where(guest_email: 'same@example.com').count).to eq(2)
    end
  end
end
