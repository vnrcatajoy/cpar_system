class Dept::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def index
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 5)
    @issues_verified = Issue.where("department_id = " + current_user.department_id.to_s + " AND status_id = 2").paginate(page: params[:page], per_page: 5)  	
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  def update
    # Dept/Issues update Would only ever be called by Assign (assign Officer) button
    @issue = Issue.find params[:id]
    @issue.status_id = 3 # Change from Verified to Investigating
    # Sure Verified first because of Assign form condition
    if @issue.update_attributes params[:issue]
      flash[:success] = 'Successfully Assigned Officer to Issue. Issue is now Investigating.'
      redirect_to dept_issues_path
    else
      redirect_to :back, notice: 'There was an error in assigning.'
    end
  end

  def show
  	@issue = Issue.find params[:id]
    @users = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 3")
    # moved Causes and ActionPlans to details view
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end
end
