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
  field :phone,             type: String

  has_secure_password

  has_and_belongs_to_many :lessons
  has_many :goals

  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w\-\.]+@[\w\-\.]+\.\w+\z/i
  validates :name,     length: { minimum: 6, maximum: 50 },
                       presence: true,
                       uniqueness: true,
                       case_sensitive: false
  validates :email,    length: { maximum: 255, allow_blank: false },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: true,
                       presence: true,
                       case_sensitive: false
  validates :password, presence: true,
                       length: { minimum: 6 },
                       on: :create
  validates :password, allow_blank: true,
                       length: { minimum: 6 },
                       format: { with: /\A\S+\z/i }
  validates :phone,    presence: true,
                       format: { with: /\d{10}/ },
                       uniqueness: true

  validate do
    check_admin_email
    non_blank_password
  end


  scope :mentor, -> { where(admin: false) }

  def first_name
    self.name.split[0]
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def to_s
    email + ": " + name
  end

  def schools
    @schools ||= School.in(id: lessons.pluck(:school_id))
  end

  def lessons
    Lesson.where(user_ids: id)
  end

  private
  # validates admin emails using the debatemate_email method
  def check_admin_email
    if admin? && !debatemate_email?
      errors.add(:email, "must be hosted at debatemate.com for admin users")
    end
  end

  #non-blank password
  def non_blank_password
    unless password.nil? || password.present?
      errors.add(:password, "cannot be blank")
    end
  end

  # is this user's email hosted on debatemate.com?
  def debatemate_email?
    len = email.length
    email[(len - 15)..(len)] == "@debatemate.com"
  end

  # turns the email into all lower case
  def downcase_email
    self.email = email.downcase
  end
end
