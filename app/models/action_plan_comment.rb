class ActionPlanComment < ActiveRecord::Base
  attr_accessible :action_plan_id, :content, :user_id #:log_comment, protected
  belongs_to :action_plan
end
