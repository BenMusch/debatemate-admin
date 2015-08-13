class User < ActiveRecord::Base
  attr_accessor :remember_token
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
  validate do
    check_admin_email
  end

  has_secure_password

  before_save :downcase_email

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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
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
      email.downcase!
    end
end
