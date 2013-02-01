class Department < ActiveRecord::Base
  has_many :issue

  attr_accessible :description, :name, :user_id
end
