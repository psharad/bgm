class TempImage < ActiveRecord::Base
  has_attached_file :photo, :styles => { :small => "80x50>" },
                    :url  => "/uploads/temp_group_image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/temp_group_image/:id/:style/:basename.:extension"
end
