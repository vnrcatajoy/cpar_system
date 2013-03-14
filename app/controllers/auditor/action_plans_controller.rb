class Auditor::ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 15)
  end

  def review
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    @action_plan.toggle!(:approved)
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
      redirect_to(root_path) unless current_user.type_id==5
  end
end
