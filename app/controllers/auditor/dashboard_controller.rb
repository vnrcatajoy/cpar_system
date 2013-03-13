class Auditor::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
