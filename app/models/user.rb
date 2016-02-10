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
  def schools
    lessons.map(&:school).flatten.uniq
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

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Checks reminders and sends any necessary reminders
  def remind
    # if the lesson is in a day and they haven't done the pre-lesson
    if lesson_tomorrow? && next_lesson.date != Date.tomorrow
      send_pre_lesson_reminder_email
    elsif Date.today == next_lesson.date
      send_lesson_reminder_email
    # if there was a lesson scheduled yesterday and no post-lesson survey was filled out
    #elsif previous_lesson.unfinished?
    # # remind the user to do the post lesson survey
    end
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

  def activate
    udpate_attribute :activated,    true
    update_attribute :activated_at, Time.zone.now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    udpate_attribute :reset_digest,  User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  def first_name
    name.split[0]
  end

  def to_s
    email + ": " + name
  end

  # returns the next lesson this user is in
  def next_lesson
    self.lessons.upcoming.first
  end

  def previous_lesson
    self.lessons.completed.first
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

    # does the user usually have a lesson tomorrow?
    def lesson_tomorrow?
      return false if Date.tomorrow.saturday? || Date.tomorrow.sunday?
      self.send("#{Date.tomorrow.strftime('%A').downcase}?")
    end

    # Sends the lesson reminder email
    def send_lesson_reminder_email
      UserMailer.lesson_reminder(self).deliver_now
    end

    # Sends the pre_lesson reminder email
    def send_pre_lesson_reminder_email
      UserMailer.lesson_reminder(self).deliver_now
    end
end
