class DashboardController < ApplicationController
  def index
    @nutritionist = Nutritionist.find_by(id: params[:nutritionist_id])
  end
end
