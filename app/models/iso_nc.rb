class IsoNc < ActiveRecord::Base
  has_many :issue

  attr_accessible :title
end
