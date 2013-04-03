class Cause < ActiveRecord::Base
  attr_accessible :closeout_date, :date_issued, :description
  has_many :cause_comments, dependent: :destroy
  belongs_to :issue
  belongs_to :user
  validates :issue_id, presence: true
  validates :user_id, presence: true
end
