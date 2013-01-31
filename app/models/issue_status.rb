class IssueStatus < ActiveRecord::Base
  has_many :issue

  attr_accessible :description, :name
end
