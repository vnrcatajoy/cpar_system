class ActionPlansController < ApplicationController
  before_filter :signed_in_user

  def new
  	@action_plan = ActionPlan.new
  end

  def create
  	@action_plan = ActionPlan.new(params[:action_plan])
  	if @action_plan.save
  		flash[:success] = "Successfully added Action Plan!" 
  	    redirect_to @action_plan
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
    if @action_plan.update_attributes(params[:action_plan])
    end
  end 

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
  end
end
