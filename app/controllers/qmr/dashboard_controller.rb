class Qmr::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end
end
