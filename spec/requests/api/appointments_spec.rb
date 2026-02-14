require 'rails_helper'

RSpec.describe Api::AppointmentsController, type: :request do
  describe 'GET /api/appointments' do
    it 'returns empty array when nutritionist_id not provided' do
      get '/api/appointments'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'returns appointments for the given nutritionist and supports status filter' do
      nutritionist = FactoryBot.create(:nutritionist)
      s1 = FactoryBot.create(:service, nutritionist: nutritionist)
      s2 = FactoryBot.create(:service)

      a1 = FactoryBot.create(:appointment, service: s1, status: :pending)
      a2 = FactoryBot.create(:appointment, service: s1, status: :accepted)
      FactoryBot.create(:appointment, service: s2, status: :pending)

      get "/api/appointments?nutritionist_id=#{nutritionist.id}"
      body = JSON.parse(response.body)
      expect(body.map { |b| b['id'] }).to include(a1.id, a2.id)

      get "/api/appointments?nutritionist_id=#{nutritionist.id}&status=accepted"
      body = JSON.parse(response.body)
      expect(body.map { |b| b['status'] }).to all(eq('accepted'))
    end
  end

  describe 'PATCH /api/appointments/:id/accept' do
    it 'accepts the appointment and rejects other pending at same time' do
      nutritionist = FactoryBot.create(:nutritionist)
      s = FactoryBot.create(:service, nutritionist: nutritionist)
      time = 2.days.from_now.change(min: 0)

      to_accept = FactoryBot.create(:appointment, service: s, start_time: time, status: :pending)
      other = FactoryBot.create(:appointment, service: s, start_time: time, status: :pending)

      expect(AppointmentMailer).to receive(:appointment_response).with(other, accepted: false).and_return(double(deliver_later: true))
      expect(AppointmentMailer).to receive(:appointment_response).with(to_accept, accepted: true).and_return(double(deliver_later: true))

      patch "/api/appointments/#{to_accept.id}/accept"
      expect(response).to have_http_status(:ok)

      expect(to_accept.reload.status).to eq('accepted')
      expect(other.reload.status).to eq('rejected')
    end
  end

  describe 'PATCH /api/appointments/:id/reject' do
    it 'rejects the appointment and sends mail' do
      s = FactoryBot.create(:service)
      appt = FactoryBot.create(:appointment, service: s, status: :pending)

      expect(AppointmentMailer).to receive(:appointment_response).with(appt, accepted: false).and_return(double(deliver_later: true))

      patch "/api/appointments/#{appt.id}/reject"
      expect(response).to have_http_status(:ok)
      expect(appt.reload.status).to eq('rejected')
    end
  end
end
