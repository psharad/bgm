class Member < ActiveRecord::Base
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :users, :through => :memberships
  belongs_to :height
  belongs_to :built
  belongs_to :ethnicity
  belongs_to :language
  belongs_to :education
  belongs_to :occupation
  
  has_attached_file :photo, :styles => { :small => "80x80>" },
                    :url  => "/uploads/members/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/members/:id/:style/:basename.:extension"
  
  validates_presence_of :email
  
  validates_presence_of :sex
  validates_presence_of :age
  # validates_presence_of :height_id
  # validates_presence_of :built_id
  # validates_presence_of :ethnicity_id
  # validates_presence_of :language_id
  # validates_presence_of :education_id
  # validates_presence_of :university
  # validates_presence_of :occupation_id
  
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  
  before_post_process :randomize_file_name
  
  def picture_from_url(url)
    self.photo = open(url)
  end
  
  def randomize_file_name
    return if photo_file_name.nil?
    # extension = File.extname(photo_file_name).downcase
    extension = ".jpeg"
    if photo_file_name_changed?
      self.photo.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end
  
end

# == Schema Information
#
# Table name: members
#
#  id            :integer(4)      not null, primary key
#  email         :string(255)
#  sex           :string(255)
#  age           :integer(4)
#  height_id     :integer(4)
#  built_id      :integer(4)
#  ethnicity_id  :integer(4)
#  language_id   :integer(4)
#  education_id  :integer(4)
#  university    :string(255)
#  occupation_id :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  in_history    :boolean(1)      default(TRUE)
#

