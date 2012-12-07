class Preference < ActiveRecord::Base
  has_one :group
  belongs_to :availability
  belongs_to :day
  belongs_to :interest
end

# == Schema Information
#
# Table name: preferences
#
#  id              :integer(4)      not null, primary key
#  interest_id     :integer(4)
#  day_id          :integer(4)
#  availability_id :integer(4)
#  description     :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  group_id        :integer(4)
#

