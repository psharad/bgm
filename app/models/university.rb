class University < ActiveRecord::Base
  #has_one :user
end

# == Schema Information
#
# Table name: universities
#
#  id         :integer(4)      not null, primary key
#  text       :string(255)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

