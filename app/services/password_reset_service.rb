class PasswordResetService
  include TwoFactorAuthenticatable

  def attribute
    @attribute ||= :reset
  end

  def mailer
    UserMailer.password_reset(user)
  end

  def updated_at_attr_name
    "reset_sent_at"
  end

  def expired?
    user.reset_sent_at < 2.hours.ago
  end
end
