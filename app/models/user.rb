## SCHEMA
#  name              (string)
#  email             (string)
#  password_digest   (string)
#  remember_digest   (string)
#  reset_digest      (string)
#  activation_digest (string)
#  admin             (boolean)
#  activated         (boolean)
#  activated_at      (datetime)
#  reset_sent_at     (datetime)
#  goals             (has-many)
#  lessons           (many-to-many through goals)
#  monday            (boolean)
#  tuesday           (boolean)
#  wednesday         (boolean)
#  thursday          (boolean
#  friday            (boolean)
#  phone             (integer)

class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :lessons, through: :goals
  has_many :goals

  before_save   :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,     length: { minimum: 6, maximum: 50 },
                       presence: true,
                       uniqueness: true,
                       case_sensitive: false
  validates :email,    length: { maximum: 255, allow_blank: false },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: true,
                       presence: true,
                       case_sensitive: false
  validates :password, length: { minimum: 6 },
                       presence: true
  validates :phone,    presence: true,
                       length: { is: 10 },
                       numericality: true,
                       uniqueness: true
  validate do
    check_admin_email
  end

  has_secure_password

  scope :mentor, -> { where(admin: false) }

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Activates this user
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Gets the first name of this user
  def first_name
    name.split[0]
  end

  def to_s
    email + ": " + name
  end

  def send_lesson_text(date)
    phone_number = phone

  end

  def send_survey_text(date)
  end

  private
    # validates admin emails using the debatemate_email method
    def check_admin_email
      if admin? && !debatemate_email?
        errors.add(:email, "must be hosted at debatemate.com for admin users")
      end
    end

    # is this user's email hosted on debatemate.com?
    def debatemate_email?
      email[(email.length - 15)..(email.length)] == "@debatemate.com"
    end

    # turns the email into all lower case
    def downcase_email
      self.email = email.downcase
    end

    # creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
