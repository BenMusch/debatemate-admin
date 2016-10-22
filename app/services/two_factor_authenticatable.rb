module TwoFactorAuthenticatable
  attr_reader :attribute, :user

  def initialize(user)
    @user = user
  end

  def attribute
    raise NotImplementedError, "Two Factor Authentication module requeres attribute variable"
  end

  def begin
    if create_digest
      mailer.deliver
      true
    else
      false
    end
  end

  def create_digest
    token = Token.new
    user.update_attributes token_attr_name() => token.token,
                           digest_attr_name() => token.digest,
                           updated_at_attr_name() => Time.zone.now
  end

  def digest_attr_name
    "#{attribute}_digest"
  end

  def token_attr_name
    "#{attribute}_token"
  end

  def updated_at_attr_name
    "#{attribute}_at"
  end

  def authenticated?(token)
    user.authenticated? attribute, token
  end
end
