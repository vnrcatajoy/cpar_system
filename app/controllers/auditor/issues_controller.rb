class Auditor::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def show
  	@issue = Issue.find params[:id]
    # moved Causes and ActionPlans to details view
  end

  def index
  	@issues = Issue.paginate(page: params[:page], per_page: 5)
    @issues_correcting = Issue.where("status_id = 4").paginate(page: params[:page], per_page: 5)
     #change to what Status/es for Issues Auditors need to see
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
