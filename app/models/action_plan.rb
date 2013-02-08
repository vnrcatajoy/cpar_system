class ActionPlan < ActiveRecord::Base
  attr_accessible :activity_id, :ap_verification_id, :description
  validates :description, presence: true
  has_many :activities
end
