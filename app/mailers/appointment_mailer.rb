class AppointmentMailer < ApplicationMailer
  def appointment_response(appointment, accepted:)
    @appointment = appointment
    @accepted = accepted
    mail(to: appointment.guest_email, subject: "Your appointment request was #{accepted ? 'accepted' : 'rejected'}")
  end
end
