class City < ActiveRecord::Base
  has_many :group
  
  named_scope :displayed, :conditions => {:is_displayed => true, :is_active => true}
  # named_scope :displayed, lambda { {:conditions =? }}
  
  validates_presence_of :name, :state, :abbrev
  
  def activate!
    update_attribute(:is_active, true)
  end
  
  def deactivate!
    update_attributes(:is_active => false, :sort_id => nil)
  end
  
  def active?
    is_active
  end
  
  def display!
    update_attribute(:is_displayed, true)
  end
  
  def hide!
    update_attribute(:is_displayed, false)
  end
  
  def displayed?
    is_displayed
  end
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#  abbrev     :string(255)
#  priority   :boolean(1)      default(FALSE)
#

