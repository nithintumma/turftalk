require 'digest'
class User < ActiveRecord::Base
  #non-accessible password
  attr_accessor :password

  #has_attached_file :avatar, :styles => { :large => "120x120>", :medium => "48x48>", :thumb => "26x26>" }
  has_attached_file :avatar, :styles => {:small => "65x65#", :thumb => "35x35#"}

  #publicly accessible and settable attributes
  attr_accessible :email, :firstname, :lastname, :password, :password_confirmation, :avatar

  #used to define the many relatinoships between users and turfs
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  #follows many turfs
  has_many :following, :through => :relationships, :source => :followed

  #owns many posts
  has_many :posts, :dependent => :destroy

  #owns many chats
  has_many :chats, :dependent => :destroy

  #owns many comments
  has_many :comments, :dependent => :destroy
  
  #owns many votes
  has_many :votes, :dependent => :destroy

  #regular expression to validate email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validates the presence, uniqueness, and length of various attributes
  validates :firstname, :presence => true, :length => { :maximum => 50 }
  validates :lastname, :presence => true
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password, :unless => "password.blank?"

  #checks if they supply the right password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #searches and authenticates by email and hashed password
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  #more secure authentication with stored salt
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  #returns if a user is a member of a given turf
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  #creates a relationship between a user and a turf
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  #removes the relationship as a user leaves a turf
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end  

  private

    #encryptys password
    def encrypt_password
      if(password != "")      
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
      end
    end

    #encrypts a given string based on a hash
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    #creates a hash for the salt
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    #function to hash any given string
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
