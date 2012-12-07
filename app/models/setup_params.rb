class SetupParams < ActiveRecord::Base
  
  serialize :user
  serialize :group
  serialize :members
  serialize :preference
  serialize :fb_ids
  
  def user=(data)
    if user.present?
      write_attribute(:user, user.deep_merge!(data))
    else             
      write_attribute(:user, data)
    end
  end
  
  def group=(data)
    if group.present?
      write_attribute(:group, group.deep_merge!(data))
    else             
      write_attribute(:group, data)
    end
  end
  
  def members=(data)
    if members.present?
      write_attribute(:members, members.deep_merge!(data))
    else             
      write_attribute(:members, data)
    end
  end
  
  def preference=(data)
    if preference.present?
      write_attribute(:preference, preference.deep_merge!(data))
    else             
      write_attribute(:preference, data)
    end
  end  

  def fb_ids=(data)
    if fb_ids.present?
      write_attribute(:fb_ids, fb_ids.deep_merge!(data))
    else             
      write_attribute(:fb_ids, data)
    end
  end  
    
end
