class Activity < ActiveRecord::Base
  attr_accessible :actual_date, :result, :target_date

  belongs_to :action_plan
  belongs_to :user
  validates :user_id, presence: true
end
