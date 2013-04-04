class Officer::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  	@action_plans = ActionPlan.all
  	@action_plans_yours = ActionPlan.where("responsible_officer_id = " + current_user.id.to_s)
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s)
  	@issues_yours = Issue.where("department_id = " + current_user.department_id.to_s + " AND responsible_officer_id = " + current_user.id.to_s)
    @nrds = NextResponsibleDepartment.where("department_id = " + current_user.department_id.to_s + " AND responsible_officer_id =  " + current_user.id.to_s)
    @issues_secondary = Array.new
    @nrds.each do |nrd|
      @issues_secondary << Issue.find(nrd.issue_id)
    end
    @issues_closeout = Issue.where("status_id = 5")
  end

  private

  def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  end
end