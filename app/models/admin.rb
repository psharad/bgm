class Admin < ActiveRecord::Base
  has_many :posts, :foreign_key => 'blogger_id'
  acts_as_authentic
  validates_presence_of :username
  validates_uniqueness_of :username
  
 # attr_accessible :username, :email, :password, :password_confirmation, :blogger, :name, :save_password, :about, :image

  has_attached_file :image, :styles => { :small => "165x150>", :medium => "300x300>", :large => "600x600>"},
                    :url  => "/uploads/admin/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/admin/:id/:style/:basename.:extension",
                    :processors => [:cropper]
                    
  # Paperclip.interpolates :normalized_file_name do |attachment, style|
  #   attachment.instance.normalized_file_name
  # end
  
  before_post_process :normalized_file_name
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_image, :if => :cropping?
  
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  def normalized_file_name
    return if image_file_name.nil?
    
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', self.image_file_name).to_s
    s.strip!
    s.downcase!
    s.gsub!(/'/, '')
    s.gsub!( /[^a-zA-Z0-9_\.]/, '-')
    
    if image_file_name_changed?
      self.image.instance_write(:file_name, s)
    end
    
  end
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def post_image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end
  
  private
  
  def reprocess_image
    image.reprocess!
  end
  
end
