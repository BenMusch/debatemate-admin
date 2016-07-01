class PasswordResetter
  #TODO refactor all of this to module w/ dynamically created method names
  include TwoFactorAuthenticatable

  def attribute
    @attribute ||= :reset
  end

  def mailer
    UserMailer.password_reset(user)
  end

  def begin
    user.reset_sent_at = Time.zone.now
    super
  end

end
