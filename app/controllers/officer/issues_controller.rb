class Officer::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  	@issues = Issue.where("status_id = 1").paginate(page: params[:page], per_page: 5)
  	#change later to all issue where responsible_officer_id = this
  	#Naturally, Responsible officer can only be assigned to Issue in his department
  end

  def show
  	@issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  private

  def responsibleofficer_user
    redirect_to(root_path) unless current_user.type_id==3
  end
end
