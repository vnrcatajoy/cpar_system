class Admin::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user

  def index
  end

  private

  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
end
