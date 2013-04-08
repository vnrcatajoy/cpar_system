class Auditor::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    # Issues
    @issues = Issue.all
    @issues_new = Issue.where("status_id = 1")
    @issues_verified = Issue.where("status_id = 2")
    @issues_investigating = Issue.where("status_id = 3")
    @issues_correcting = Issue.where("status_id = 4")
    @issues_closeout = Issue.where("status_id = 5")
    @issues_closed = Issue.where("status_id = 6")
    @issues_rejected = Issue.where("status_id = 7 OR status_id = 8")
    # Action Plans
  	@action_plans = ActionPlan.all
  	@action_plans_new = ActionPlan.where("ap_status_id = 1")
  	@action_plans_review = ActionPlan.where("ap_status_id = 2")
    @action_plans_markasimplement = ActionPlan.where(ap_status_id: 2, implemented: 't')
  	# For reviewing if ACtion Plan properly implemented
    @closeoutforms_started = CloseoutForm.where(auditor_id: current_user.id)
    @closeoutforms_finished = CloseoutForm.where(auditor_id: current_user.id, completed: 't')
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
