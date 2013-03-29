class IssuesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :edit]
  before_filter :correct_submitter, only: [:edit]
  before_filter :correct_department, only: [:show]

  def index
    # still needs to be revised further
    if current_user.admin?  #super admin
      @issues = Issue.paginate(page: params[:page], per_page: 10)
    else  #get issues reported to you or your department
      @issues = Issue.where("department_id = " + current_user.department_id.to_s + " OR user_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 10)
    end
      @issues_yours = Issue.where("user_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]
    if @issue.save
      redirect_to issues_path, notice: 'The issue has been created!'
    else
      redirect_to :back, notice: 'There was an error in creating your issue.'
    end
  end

  def show
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  def edit
    @issue = Issue.find params[:id]
  end

  def update
    issue = Issue.find params[:id]
    if issue.update_attributes params[:issue]
      flash[:success] = "The issue has been updated successfully!"
      redirect_to issue_path  
    else
      flash[:error] = "There was an error in updating your issue."
      redirect_to :back
    end
  end

  private
  def correct_department
    @issue = Issue.find params[:id]
    if current_user.department_id != @issue.department_id
      if !current_user.admin? 
      #remove this condition if admin mustn't be allowed to view all Issues in public
        if current_user.id == @issue.user_id
          #flash[:success] = "Viewing your submitted Issue."
        else
          flash[:error] = "You cannot view that Issue."
          redirect_to issues_path
        end
      end 
    end
  end

  def correct_submitter
    @issue = Issue.find params[:id]
    if current_user.id != @issue.user_id 
      flash[:error] = "You cannot Edit that Issue."
      redirect_to issue_path
    end
  end

end
