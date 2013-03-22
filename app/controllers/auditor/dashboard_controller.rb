class Auditor::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
  	@action_plans = ActionPlan.all
  	@action_plans_new = ActionPlan.where("ap_status_id = 1")
  	@action_plans_review = ActionPlan.where("ap_status_id = 2")
    @action_plans_markasimplement = ActionPlan.where(ap_status_id: 2, implemented: 't')
  	# For reviewing if ACtion Plan properly implemented
  	@issues = Issue.all
  	@issues_verified = Issue.where("status_id = 2")
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
