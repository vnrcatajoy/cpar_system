class ActionPlansController < ApplicationController
  before_filter :signed_in_user

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 15)
  end

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
  end

end
