class User < ActiveRecord::Base
	has_many :videos
	has_many :likes
	belongs_to :role
	before_save { self.email = email.downcase }
	before_create :confirmation_token
	validates :username, presence: true, length: { minimum: 3, maximum: 40 }, uniqueness: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 105 }, uniqueness: { case_sensitive: false },
	                                format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6, maximum: 32 }, confirmation: true
	has_secure_password
	scope :check_user, ->( user_name ) { where("username = ? or email = ?", user_name, user_name) }

	def email_active
	self.email_confirmed = true
	self.confirm_token = nil
	save!(:validate => false)
	end
	private
	def confirmation_token
	    if self.confirm_token.blank?
	      self.confirm_token = SecureRandom.urlsafe_base64.to_s
	    end
	end
end
