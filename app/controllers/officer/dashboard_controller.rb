class Officer::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  end

  private

  def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id=3
  end
end