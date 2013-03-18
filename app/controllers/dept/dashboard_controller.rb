class Dept::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def index
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end
end
