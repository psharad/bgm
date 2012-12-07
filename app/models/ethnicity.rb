class Ethnicity < ActiveRecord::Base
  has_many :users
  has_many :members
end

# == Schema Information
#
# Table name: ethnicities
#
#  id         :integer(4)      not null, primary key
#  text       :string(255)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

