class UserAuthenticator
  include TwoFactorAuthenticable

  def activate
    if !user.activated? && user.authenticated(:activation, params[:id])
      self.user.update_attribute :activated, true
      self.user.update_attribute :activated_at, Time.zone.now
      true
    else
      false
    end
  end

  def mailer
    UserMailer.account_activation(user)
  end

  def attribute
    @attribute ||= :activation
  end
end
