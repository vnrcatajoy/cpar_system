class Officer::ActivitiesController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user
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
      redirect_to [:officer, @action_plan]
    else
      flash.now[:error] = "Please fill in the fields properly." 
      render 'new'
    end
  end

  def show
    @activity=Activity.find(params[:id])
  end

  def edit
    flash[:success] = "Editing Activity" 
    #@activity = Activity.find(params[:id])
    @activity = @action_plan.activities.find(params[:id])
  end

  def update
    #@activity = Activity.find(params[:id])
    @activity = @action_plan.activities.find(params[:id])
    if @activity.update_attributes(params[:activity])
      flash[:success] = "Activity updated."
      redirect_to [:officer, @action_plan]
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = "Activity destroyed!"
    redirect_to [:officer, @action_plan]
  end

  private
    def actionplan_notnil
      @action_plan = ActionPlan.find(params[:action_plan_id])
      #redirect_to action_plans_path if @action_plan.nil?
    end

    def set_user
      @user = current_user
    end

    def responsibleofficer_user
      redirect_to(root_path) unless current_user.type_id=3
  end
end
