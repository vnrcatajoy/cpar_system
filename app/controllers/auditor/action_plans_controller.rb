class Auditor::ActionPlansController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def index
    @action_plans = ActionPlan.paginate(page: params[:page],  per_page: 10)
    @action_plans_new = ActionPlan.where("ap_status_id = 1").paginate(page: params[:page],  per_page: 5)
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
    @action_plan.ap_status_id = 6 #previously Rejected was 5
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor rejected Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Rejected. It will now be closed for edits."
      redirect_to auditor_action_plan_path
    end
  end

  def activity_statuschange
    @action_plan = ActionPlan.find params[:id]
  end

  def update_activities
    @action_plan = ActionPlan.find params[:id]
    outstring = "Approved: "
    activities_approved = Array.new
    activities_rejected = Array.new
    if params[:action_plan][:approve_list] != nil
      params[:action_plan][:approve_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:reject_list]) == false
          act = Activity.find(act_id)
          outstring += "- " + act.result + ", "
          # append to final approve array of Activities if no conflict
          activities_approved << act
        end
      end
    end
    outstring += " Rejected: "
    if params[:action_plan][:reject_list] != nil
      params[:action_plan][:reject_list].each do |act_id|
        if in_opposite_list(act_id, params[:action_plan][:approve_list]) == false
          act = Activity.find(act_id)
          outstring += "- " + act.result + ", "
          # append to final reject array of Activities if no conflict
          activities_rejected << act
        end
      end
    end
    if activities_approved != nil
      activities_approved.each do |a|
        # approve them one at a time
        a.status_id = 2 #Reviewed/ Initial Approval
        a.save
      end
    end
    if activities_rejected != nil
      activities_rejected.each do |a|
        # reject them one at a time
        a.status_id = 6 #Rejected
        a.save
      end
    end
    #flash[:success] =  "Status: "+ activities_approved.count.to_s + " activities approved, "+ activities_rejected.count.to_s+" activities rejected"
    #redirect_to :back
    activities_all_approved_check(@action_plan, 2)
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

  def not_implemented
    @action_plan = ActionPlan.find params[:id]
    @action_plan.toggle!(:implemented)
    @officer = User.find(@action_plan.responsible_officer_id)
    if @action_plan.save
      @ac= @action_plan.action_plan_comments.build({content: "Auditor marked Action Plan as not yet Implemented fully.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
      @ac.toggle!(:log_comment)
      @ac.save
      flash[:success] = "Action Plan Marked as not yet fully Implemented. Officer will receive a notification about this."
      redirect_to auditor_action_plan_path
      title = "Submitted Action Plan was marked as not yet Implemented"
      content = "Your Submitted Action Plan was deemed not yet fully Implemented by Auditor, please redo your Implementation or finish more Activities for this Action Plan."
      @officer.send_notification_email(title, content)
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

  def in_opposite_list(id, arrayparams)
    found = false
    if arrayparams != nil
      arrayparams.each do |a|
        if id == a
          found = true
        end
      end
    end
    found
  end

  def activities_all_approved_check(action_plan, stat_id)
    all_approved = true
    if action_plan.activities != nil
      action_plan.activities.each do |act|
        if act.status_id != stat_id && act.status_id != 6 
        # 2 is the status_id for Approved/Verified Activity, 6 for Rejected
        # Basically now ignores Rejected activities in checking if all Approved
          all_approved = false
          # If there's a remaining Rejected Activity still undeleted, it won't register as all approved
        end
      end
    end
    # Officer should delete activities that got rejected
    if all_approved
      action_plan.ap_status_id = 2
      # New to Verified and Verified to Implemented is +1
      action_plan.ap_reviewer_id = current_user.id
      action_plan.final_review_date = Date.today
      if action_plan.save
        @ac= @action_plan.action_plan_comments.build({content: "Auditor reviewed Action Plan.",
            user_id: current_user.id, action_plan_id: @action_plan.id })
        @ac.toggle!(:log_comment)
        @ac.save
        flash[:success] = "All Activities marked as Approved. Action Plan successfully reviewed."
        redirect_to auditor_action_plan_path(action_plan)
      end
    else
      # Not all Approved yet
      flash[:success] = "Activities successfully reviewed. Not all are approved yet."
      redirect_to auditor_action_plan_path(action_plan)
    end
  end

end
