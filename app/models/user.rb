class User < ActiveRecord::Base
  has_many :assignments
  has_many :roles, :through => :assignments
  has_many :work_assignments
  has_many :paths, :through => :work_assignments

  has_many :watchings
  belongs_to :iteration

  has_many :iteration_resources, :dependent => :destroy
  has_many :build_iterations, :through => :iteration_resources 
  # new columns need to be added here to be writable through mass assignment
#  attr_accessible :username, :email, :password, :password_confirmation

  attr_accessor :password, :full_name
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  attr_writer :full_name

  def full_name
    if  name
       @full_name =  "'" + name + " " + last_name + "'"
    else
       @full_name =   username + "(Empty name)"
    end

  end

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end

