class Membership < ActiveRecord::Base
  belongs_to :member
  belongs_to :group
end

# == Schema Information
#
# Table name: memberships
#
#  id         :integer(4)      not null, primary key
#  group_id   :integer(4)
#  user_id    :integer(4)
#  member_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

