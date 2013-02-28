class ActionPlan < ActiveRecord::Base
  attr_accessible :description, :final_review_date, :final_implementation_review_date
  validates :description, presence: true
  has_many :activities, dependent: :destroy
  # also has ap_reviewer_id and implementation_reviewer_id for its user_ids
end
