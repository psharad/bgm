class Interest < ActiveRecord::Base
  has_many :preferences
  default_scope :conditions => {:is_deleted => nil}
end

# == Schema Information
#
# Table name: interests
#
#  id         :integer(4)      not null, primary key
#  text       :string(255)
#  is_deleted :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

