class AppointmentsController < ApplicationController
  protect_from_forgery with: :exception

  def create
    appointment_params = params.require(:appointment).permit(:guest_name, :guest_email, :start_time, :service_id)

    Appointment.transaction do
      # Invalidate any existing pending requests from the same guest (same email)
      if appointment_params[:guest_email].present?
        Appointment.where(guest_email: appointment_params[:guest_email], status: :pending).update_all(status: :rejected)
      end

      appointment = Appointment.new(appointment_params.merge(status: :pending))

      if appointment.save
        render json: { success: true, id: appointment.id }, status: :created
      else
        render json: { success: false, errors: appointment.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end
end
