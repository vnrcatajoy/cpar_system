class Dept::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user

  def index
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 5)
  	#change later to all issue where responsible_officer_id = this
  	#Naturally, Responsible officer can only be assigned to Issue in his department
  end

  def update
    @issue = Issue.find params[:id]
    if @issue.update_attributes params[:issue]
      flash[:success] = 'Successfully assigned User.'
      redirect_to dept_issues_path
    else
      redirect_to :back, notice: 'There was an error in assigning.'
    end
  end

  def show
  	@issue = Issue.find params[:id]
    @users = User.where("department_id = " + current_user.department_id.to_s)
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end
end
