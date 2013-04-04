class Dept::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def index
  	@users = User.where("department_id = " + current_user.department_id.to_s)
    @users_officers = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 3")
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s)
  	@issues_verified = Issue.where("department_id = " + current_user.department_id.to_s + " AND status_id = 2")
    @nrds = NextResponsibleDepartment.where("department_id = " + current_user.department_id.to_s)
    @issues_secondary = Array.new
    @nrds.each do |nrd|
      @issues_secondary << Issue.find(nrd.issue_id)
    end
    @issues_closeout = Issue.where("status_id = 5")
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end
end
