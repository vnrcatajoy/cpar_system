class Auditor::ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def new
  	@action_plan = ActionPlan.new
  end

  def create
  	@action_plan = ActionPlan.new(params[:action_plan])
  	if @action_plan.save
  		flash[:success] = "Successfully added Action Plan!" 
  	    redirect_to auditor_action_plan_path(@action_plan)
  	else
  		flash.now[:error] = "Please fill in the fields properly." 
  		render 'new'
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
      redirect_to auditor_action_plan_path
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end 

  def review
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    if @action_plan.save
      flash[:success] = "Action Plan successfully reviewed."
      redirect_to auditor_action_plan_path
    end
  end

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
  end

  def destroy
    ActionPlan.find(params[:id]).destroy
    flash[:success] = "Action Plan destroyed."
    redirect_to auditor_action_plans_path
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id=5
  end
end
