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
      @ac= @action_plan.action_plan_comments.build({content: "Officer added an Activity to Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Successfully added Activity!" 
      redirect_to [:officer, @action_plan]
    else
      flash.now[:error] = "Please fill in the fields properly." 
      render 'new'
    end
  end

  def mark_done
    @action_plan=ActionPlan.find(params[:action_plan])
    @activity = Activity.find(params[:id])
    @activity.actual_date = Date.today
    @activity.status_id = 3
    if @activity.save
      flash[:success] = "Activity marked as Done!"
      redirect_to [:officer, @action_plan]
    else
      flash[:error] = "Error while marking Activity as Done"
      redirect_to :back
    end
  end

  def show
    @activity=Activity.find(params[:id])
  end

  def edit
    #@activity = Activity.find(params[:id])
    @activity = @action_plan.activities.find(params[:id])
  end

  def update
    #@activity = Activity.find(params[:id])
    @activity = @action_plan.activities.find(params[:id])
    if @activity.update_attributes(params[:activity])
      @ac= @action_plan.action_plan_comments.build({content: "Officer updated an Activity's details.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Activity updated."
      redirect_to [:officer, @action_plan]
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    @ac= @action_plan.action_plan_comments.build({content: "Officer deleted an Activity from Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
    @ac.toggle!(:log_comment)
    @ac.save
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
      redirect_to(root_path) unless current_user.type_id==3
  end
end
