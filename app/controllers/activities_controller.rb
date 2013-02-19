class ActivitiesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :actionplan_notnil
  before_filter :set_user

  def new
    @activity = Activity.new(params[:activity])
  end

  def create
    @activity = @action_plan.activities.build(params[:activity])
    @activity.user_id = @user.id 
    if @activity.save
      flash[:success] = "Successfully added Activity!" 
      redirect_to(action_plans_path || root_path)
    else
      flash.now[:error] = "Please fill in the fields properly." 
      render 'new'
    end
  end

  def index
  end

  def show
    @activity=Activity.find(params[:id])
  end

  def edit
    flash[:success] = "Editing Activity" 
    @activity = Activity.find params[:id]
  end

  def update
    if @activity.update_attributes(params[:activity])
    end
  end

  private
    def actionplan_notnil
      @action_plan = ActionPlan.find(params[:action_plan_id])
      #redirect_to action_plans_path if @action_plan.nil?
    end

    def set_user
      @user = current_user
    end

end