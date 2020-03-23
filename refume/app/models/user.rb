class User < ApplicationRecord
  # explicitly tells Rails the foreign_key is "mentor_id"
  # An id used to connect two database tables is known as a foreign key
  # This is an active match relationship for someone who initiates a match
  #has_many :active_matches, class_name: "Match", foreign_key: "mentor_id", dependent: :destroy
  # While for someone who does not initiates a match and get arrange to a match is passive match
  #has_many :passive_matches, class_name:  "Match", foreign_key: "mentee_id", dependent: :destroy

  # explicitly tells Rails that the source of the 'mentor_id array' is the set of 'mentor ids'.
  #has_many :following, through: :active_matches, source: :mentee
  #has_many :followers, through: :passive_matches, source: :mentor

  # remember_token and activation_token are a virtual attribute for User
  # It used to store a token for the user.
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :age, :zipcode, :numericality => { :greater_than_or_equal_to => 0 }
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validate :password_complexity

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # This is a class method
  # Returns a random token(string).
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Creates and assigns the activation token and digest.
  # activation_token is a virtual attribute (will be stored in memory only)
  # activation_digest is a class attribute (will be saved in the user table)
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Returns true if the given token matches the digest.
  # here attribute vairaible is generic, because it's used for
  # both remember_digest and activation_digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

end
