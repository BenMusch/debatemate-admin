class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  attr_accessor :activation_token, :reset_token, :remember_token

  field :name,              type: String
  field :email,             type: String
  field :password_digest,   type: String
  field :remember_digest,   type: String
  field :reset_digest,      type: String
  field :activation_digest, type: String
  field :admin,             type: Boolean, default: ->{ false }
  field :activated,         type: Boolean, default: ->{ false }
  field :activated_at,      type: DateTime
  field :reset_sent_at,     type: DateTime
  field :monday,            type: Boolean
  field :tuesday,           type: Boolean
  field :wednesday,         type: Boolean
  field :thursday,          type: Boolean
  field :friday,            type: Boolean
  field :phone,             type: Integer

  has_and_belongs_to_many :lessons
  has_many :goals

  before_save   :downcase_email

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

  def first_name
    self.name.split[0]
  end

  def schools
    self.lessons.map(&:school).flatten.uniq
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = Token.new_token
    update_attribute(:remember_digest, Token.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil 
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def to_s
    email + ": " + name
  end

  def lessons
    Lesson.where(user_ids: self._id)
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
end
