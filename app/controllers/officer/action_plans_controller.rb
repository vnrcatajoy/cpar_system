class Officer::ActionPlansController < ApplicationController
before_filter :signed_in_user
before_filter :responsibleofficer_user

  def new
  	@action_plan = ActionPlan.new
    @issues = Issue.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 5)
    #change later to all issue where responsible_officer_id = this
    #Naturally, Responsible officer can only be assigned to Issue in his department
  end

  def create
  	@action_plan = ActionPlan.new(params[:action_plan])
    @action_plan.responsible_officer_id = current_user.id
    #since those who make action plans are responsible officers
  	if @action_plan.save
  		flash[:success] = "Successfully added Action Plan!" 
  	    redirect_to officer_action_plan_path(@action_plan)
  	else
  		flash.now[:error] = "Please fill in the fields properly." 
  		render 'new'
  	end
  end

  def implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.toggle!(:implemented)
    if @action_plan.save
      flash[:success] = "Action Plan successfully marked as implemented. 
      Status now pending to be changed to Implemented."
      redirect_to officer_action_plan_path
    end
  end

  def edit
  	@action_plan = ActionPlan.find params[:id]
  end

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 15)
  end

  def update
    @action_plan = ActionPlan.find params[:id]
    if @action_plan.update_attributes(params[:action_plan])
      flash[:success] = "Action Plan updated."
      redirect_to officer_action_plan_path
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end 

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
  end

  private

  def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id==3
  end
end
