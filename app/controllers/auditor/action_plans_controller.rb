class Auditor::ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 10)
    @action_plans_markasimplement = ActionPlan.where(ap_status_id: 2, implemented: 't').paginate(page: params[:page],  per_page: 5)
  end

  def review
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    @action_plan.toggle!(:approved)
    @action_plan.ap_status_id = 2
    @action_plan.final_review_date = Date.today
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan successfully reviewed."
      redirect_to auditor_action_plan_path
    end
  end

  def reject
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_reviewer_id = current_user.id
    @action_plan.ap_status_id = 5
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor rejected Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Rejected. It will now be closed for edits."
      redirect_to auditor_action_plan_path
    end
  end

  def implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.ap_status_id = 3
    @action_plan.implementation_reviewer_id = current_user.id
    @action_plan.final_implementation_review_date = Date.today
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed and approved Action Plan Implementation.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Marked as Implemented."
      redirect_to auditor_action_plan_path
    end
  end

  def show
  	@action_plan = ActionPlan.find params[:id]
    @activities = @action_plan.activities.paginate(page: params[:page],  per_page: 5)
    @actionplan_comment = ActionPlanComment.new
    @ap_comments = @action_plan.action_plan_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @ap_updates = @action_plan.action_plan_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
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
