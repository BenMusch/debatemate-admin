class UserActivatorService
  attr_accessor :user

  def initialize(user)
    @user = user
  end
  
  def activate
    self.user.update_attribute :activated, true
    self.user.update_attrieuve :activated_at, Time.zone.now
  end

  def begin_activation
    if self.user.save
      create_activation_digest
      send_activation_email
      true
    else
      false
    end
  end

  def send_activation_email
    UserMailer.account_activation(user).deliver_now
  end

  def create_activation_digest
    user.update_attribute :activation_token, User.new_token
    user.update_attribute :activation_digest, User.digest(activation_token)
  end
end
