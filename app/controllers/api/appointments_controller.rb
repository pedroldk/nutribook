module Api
  class AppointmentsController < ApplicationController
    protect_from_forgery with: :null_session

    # GET /api/appointments?nutritionist_id=1[&status=pending|accepted]
    def index
      nutritionist_id = params[:nutritionist_id]
      return render json: [] unless nutritionist_id.present?

      appts = Appointment.joins(:service)
        .where(services: { nutritionist_id: nutritionist_id })
        .includes(:service)

      # Optionally filter by status if provided
      if params[:status].present?
        appts = appts.where(status: params[:status])
      end

      render json: appts.map(&:as_api_json)
    end

    # PATCH /api/appointments/:id/accept
    def accept
      appointment = Appointment.find(params[:id])
      Appointment.transaction do
        appointment.accepted!

        # Reject other pending requests for the same nutritionist at the same date/time
        nutritionist_id = appointment.service.nutritionist_id
        same_time = appointment.start_time

        others = Appointment.joins(:service)
          .where(services: { nutritionist_id: nutritionist_id })
          .where(start_time: same_time)
          .where(status: :pending)
          .where.not(id: appointment.id)

        others.find_each do |o|
          o.rejected!
          AppointmentMailer.appointment_response(o, accepted: false).deliver_later
        end

        AppointmentMailer.appointment_response(appointment, accepted: true).deliver_later
      end

      render json: appointment.as_api_json
    end

    # PATCH /api/appointments/:id/reject
    def reject
      appointment = Appointment.find(params[:id])
      appointment.rejected!
      AppointmentMailer.appointment_response(appointment, accepted: false).deliver_later
      render json: appointment.as_api_json
    end
  end
end
