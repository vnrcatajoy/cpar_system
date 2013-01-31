class Department < ActiveRecord::Base
  has_many :issue

  attr_accessible :description, :name, :owner_id
end
