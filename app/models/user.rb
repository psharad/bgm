class User < ActiveRecord::Base
  belongs_to :height
  belongs_to :built
  belongs_to :ethnicity
  belongs_to :language
  belongs_to :education
  belongs_to :occupation
  belongs_to :preference
  
  attr_reader :password, :password_confirmation
  
  has_many :groups, :dependent => :destroy
  accepts_nested_attributes_for :groups
  
  has_many :memberships
  has_many :members, :through => :memberships
  has_many :local_offers
  
  acts_as_authentic
  
  validates_presence_of :sex
  validates_presence_of :age
  # validates_presence_of :height_id
  # validates_presence_of :built_id
  # validates_presence_of :ethnicity_id
  # validates_presence_of :language_id
  # validates_presence_of :education_id
  #validates_presence_of :university
  # validates_presence_of :occupation_id
  
  attr_writer :current_step
  
  after_create :generate_rollback_token
  
  def current_step
    @current_step || steps.first
  end
  
  def steps
    %w[group method user end]
  end
  
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
  private
    
    def generate_rollback_token
      update_attribute(:rollback_token, Digest::SHA1.hexdigest([created_at, id].join))
    end
end

# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  email             :string(255)
#  sex               :string(255)
#  age               :integer(4)
#  height_id         :integer(4)
#  built_id          :integer(4)
#  ethnicity_id      :integer(4)
#  language_id       :integer(4)
#  education_id      :integer(4)
#  university        :string(255)
#  occupation_id     :integer(4)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  remember_me       :boolean(1)      default(TRUE)
#  perishable_token  :string(255)
#

