class LocalOffer < ActiveRecord::Base
  belongs_to :admin
  has_many :local_offers_tracks

  validates_presence_of :title
  
  has_attached_file :image, :styles => { :small => "165x150>", :medium => "300x300>", :large => "600x600>"},
                    :url  => "/uploads/local_offer/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/local_offer/:id/:style/:basename.:extension",
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
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def post_image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end
  
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
  
  private
  
  def reprocess_image
    image.reprocess!
  end
  
end
