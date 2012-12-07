class Day < ActiveRecord::Base
  has_many :preference
end

# == Schema Information
#
# Table name: days
#
#  id         :integer(4)      not null, primary key
#  text       :string(255)
#  is_deleted :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

