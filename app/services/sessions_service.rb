class SessionsService
  attr_accessor :user

  def initialize(user, cookies, params: {})
    @user = user
    @cookies = cookies
    @params = params
  end

  def remember
    user.remember_token = Token.new_token
    user.update_attribute :remember_digest, Token.digest(user.remember_token)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget
    user.update_attribute :remember_digest, nil
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_in
    session[:user_id] = user.id
  end

  def log_out
    forget
    session.delete(:user_id)
  end
end
