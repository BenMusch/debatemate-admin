module TwoFactorAuthenticatable
  attr_reader :attribute, :user

  def initialize(user)
    @user = user
  end

  def attribute
    raise NotImplementedError, "Two Factor Authentication module requeres attribute variable"
  end

  def begin
    create_digest
    send_email
  end

  def create_digest
    token = Token.new
    user.send digest_attr_name + "=", token.digest
    user.send token_attr_name + "=", token.token
    user.send updated_at_attr_name + "=", Time.zone.now
    user.save
  end

  def send_email
    mailer.deliver_now
  end

  def digest_attr_name
    "#{attribute}_digest"
  end

  def token_attr_name
    "#{attribute}_digest"
  end

  def update_at_attr_name
    "#{attribute}_at"
  end
end
