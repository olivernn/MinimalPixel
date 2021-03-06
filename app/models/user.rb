require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  # Validations
  validates_presence_of :login, :if => :not_using_openid?
  validates_length_of :login, :within => 3..40, :if => :not_using_openid?
  validates_uniqueness_of :login, :case_sensitive => false, :if => :not_using_openid?
  validates_format_of :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :if => :not_using_openid?
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :name
  validates_presence_of :email, :if => :not_using_openid?
  validates_length_of :email, :within => 6..100, :if => :not_using_openid?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :not_using_openid?
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?
  validates_uniqueness_of :identity_url, :unless => :not_using_openid?
  validate :normalize_identity_url
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_exclusion_of :subdomain, :in => %w(admin blog support forum assets media developer assets0 assets1 assets2 assets3) # these are reserved subdomains
  validates_format_of :subdomain, :with => RE_SUBDOMAIN_OK, :message => MSG_SUBDOMAIN_BAD
  
  # Relationships
  has_and_belongs_to_many :roles
  has_one :plan, :through => :account, :source => :plan
  has_one :account
  has_one :profile, :dependent => :destroy
  has_one :style, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :pages, :dependent => :destroy

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :subdomain, :terms_and_conditions
  
  # confirms terms and conditions have been accepted
  attr_accessor :terms_and_conditions
  validates_acceptance_of :terms_and_conditions
  
  # callbacks
  before_save :prepare_subdomain
  after_create :register_user_to_fb

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => { :login => login } # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  def admin?
    self.has_role?("admin")
  end
  
  # Not using open id
  def not_using_openid?
    identity_url.blank?
  end
  
  # Overwrite password_required for open id
  def password_required?
    new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?) : !password.blank?
  end
  
  # methods for determening how many projects, images and videos the user can set up
  def projects_available
    self.plan.project_limit - self.projects.count
  end
  
  def images_available
    x = 0
    self.projects.each {|p| x = x + p.images.count}
    self.plan.image_limit - x
  end
  
  def videos_available
    x = 0
    self.projects.each {|p| x = x + p.videos.count}
    self.plan.video_limit - x
  end
  
  def can_create_projects?
    self.projects_available > 0
  end
  
  def can_add_images?
    self.images_available > 0
  end
  
  def can_add_videos?
    self.videos_available > 0    
  end
  
  # --- FB CONNECT METHODS --- #
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end
  
  def self.create_from_fb_connect(fb_user)
    new_facebooker = User.new(:name => fb_user.name,
                              :login => "FB_" + fb_user.first_name + "_" + fb_user.last_name,
                              :password => fb_user.last_name,
                              :password_confirmation => fb_user.last_name,
                              :email => fb_user.proxied_email,
                              :subdomain => fb_user.name)
                              
    new_facebooker.fb_user_id = fb_user.uid.to_i
    new_facebooker.save_with_validation(false)
    new_facebooker.register_user_to_fb
    new_facebooker
  end
  
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save
      end
      self.fb_user_id = fb_user_id
      save(false)
    end
  end
  
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save_with_validation(false)
  end
  
  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end
  
  def facebook_user_details
    if self.facebook_user?
      @facebook_user_details ||= Facebooker::User.new(self.fb_user_id)
    end
  end
  
  def allows_fb_email?
    if self.facebook_user?
      @allow_fb_email ||= self.facebook_user_details.has_permission?('email')
    end
  end
  
  def allows_fb_publish?
    if self.facebook_user?
      @allow_fb_publish ||= self.facebook_user_details.has_permission?('publish_stream')
    end
  end
  # --- FB CONNECT END --- #
  
  protected
    
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_url(identity_url) unless not_using_openid?
  rescue URI::InvalidURIError
    errors.add_to_base("Invalid OpenID URL")
  end
  
  def prepare_subdomain
    self.subdomain = self.subdomain.downcase.gsub(' ', '-') if self.subdomain
  end
end
