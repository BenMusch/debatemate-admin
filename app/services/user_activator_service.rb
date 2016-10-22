class UserActivatorService
  include TwoFactorAuthenticatable

  def activate(token)
    if user && authenticated?(token)
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
    :activation
  end

  def updated_at_attr_name
    "activated_at"
  end
end
