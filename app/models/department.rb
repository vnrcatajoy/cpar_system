class Department < ActiveRecord::Base
  has_many :issues
  
  attr_accessible :description, :name
end
