class ActivitiesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: [:edit, :update]

  def new
    @action_plan = ActionPlan.find_by_id(params[:action_plan_id])
    @activity = @action_plan.activities.build
  end

  def create
    @action_plan = ActionPlan.find_by_id(params[:action_plan_id])
    @activity = @action_plan.activities.build(params[:activity])
    #@activity = Activity.new(params[:activity])
    if @activity.save
      flash[:success] = "Successfully added Activity!" 
      redirect_to action_plan_path
    else
      flash.now[:error] = "Please fill in the fields properly." 
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

end