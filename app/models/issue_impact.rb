class IssueImpact < ActiveRecord::Base
  has_many :issue

  attr_accessible :name
end
