require 'rails_helper'

RSpec.describe AppointmentMailer, type: :mailer do
  describe '#appointment_response' do
    let(:service) { FactoryBot.create(:service) }
    let(:appointment) { FactoryBot.create(:appointment, service: service, guest_email: 'u@example.com') }

    it 'renders headers and recipient' do
      mail = AppointmentMailer.appointment_response(appointment, accepted: true)
      expect(mail.to).to include('u@example.com')
      expect(mail.subject).to match(/accepted/)
    end

    it 'renders both html and text parts' do
      mail = AppointmentMailer.appointment_response(appointment, accepted: false)
      expect(mail.body.encoded).to include(appointment.guest_name)
      expect(mail.body.encoded).to include(appointment.service.name)
    end
  end
end
