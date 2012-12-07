require "open-uri"
class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  has_many :memberships
  has_many :members, :through => :memberships
  has_one  :preference
  has_attached_file :photo, :styles => { :small => "80x80>" },
                    :url  => "/uploads/group/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/group/:id/:style/:basename.:extension"
  # validates_attachment_presence :photo
  # validates_attachment_size :photo, :less_than => 5.megabytes

  validates_presence_of :city_id
  validates_presence_of :zip
  validates_presence_of :size
  validates_presence_of :gender
  #validates_presence_of :match_preference
  validates_format_of :name, :with => /[\w\d]+/i, :message => "of group is invalid."
  
  before_post_process :randomize_file_name
  
  has_friendly_id :name, :use_slug => true, :sequence_separator => '-'
  
  searchable do
    integer :city_id
    string :zip
    string :gender
    integer :size
    string :photo_file_name
    time :expiration_date
    boolean :is_deactivated
    integer :group_size do
      begin
        members.count+1
      rescue
        1
      end
    end
  end
  
  def picture_from_url(url)
    self.photo = open(url)
  end
  
  def self.current_group
    # first(:conditions => ["expiration_date > ? AND is_deactivated = 0", Time.now])
    first(:conditions => ["is_deactivated = 0"])
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
# Table name: groups
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  zip                :string(255)
#  gender             :string(255)
#  size               :integer(4)
#  match_preference   :integer(4)
#  user_id            :integer(4)
#  expiration_date    :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  city_id            :integer(4)
#

