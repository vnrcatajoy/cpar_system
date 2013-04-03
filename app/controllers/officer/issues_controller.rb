class Officer::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user

  def index
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 5)
  	#change later to all issue where responsible_officer_id = this
  	#Naturally, Responsible officer can only be assigned to Issue in his department
    @issues_yours = Issue.where("department_id = " + current_user.department_id.to_s + " AND responsible_officer_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 5)
    @nrds = NextResponsibleDepartment.where("department_id = " + current_user.department_id.to_s + " AND responsible_officer_id =  " + current_user.id.to_s)
    @issues_secondary = Array.new
    @nrds.each do |nrd|
      @issues_secondary << Issue.find(nrd.issue_id)
    end
  end

  def show
  	@issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    # Decide if will move Causes and ActionPlans to details view for Officer controls
  end

  def sign_closeout
    @issue = Issue.find params[:id]
    @cofd = CloseoutFormDept.find_by_id(params[:cofd])
    if @cofd.officer_id == nil 
      @cofd.officer_id = current_user.id
      if @cofd.save
        flash[:success] = "Successfully signed Closeout form of Issue!"
        redirect_to details_officer_issue_path(@issue)
      end
    end
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  private
  def responsibleofficer_user
    redirect_to(root_path) unless current_user.type_id==3
  end
end
