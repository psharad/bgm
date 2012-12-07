class Language < ActiveRecord::Base
  has_many :user
  has_many :member
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer(4)      not null, primary key
#  text       :string(255)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#
