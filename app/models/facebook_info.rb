class FacebookInfo < ActiveRecord::Base
  
  def self.get_gender(fb,dtype=nil)
    begin
      case dtype
      when 'member'
        return fb.capitalize
      else
        return fb.gender.capitalize
      end
    rescue
      return nil
    end
  end
  
  def self.get_age(fb,dtype=nil)
    begin
      case dtype
      when 'member'
        return ((Date.today - fb.to_date).to_i)/365
      else
        return ((Date.today - fb.birthday.to_date).to_i)/365
      end
    rescue
      return nil
    end
  end
  
end