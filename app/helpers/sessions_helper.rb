module SessionsHelper
  # Logs in the given UsersLoginTest
  def log_in(user)
    SessionsService.new(user)
  end

  # Returns the current logged-in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user = nil if @current_user && @current_user.id != user_id
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Is the current user logged in?
  def logged_in?
    !current_user.nil?
  end

  # Is the current user an admin?
  def admin?
    current_user && current_user.admin?
  end

  # Forgets a persistent session
  def forget(user)
    SessionsService.new(user).forget
  end

  # Logs out the current user
  def log_out
    SessionsService.new(current_user).log_out
    @current_user = nil
  end

  # Remembers a user in a persistent session
  def remember(user)
    SessionsService.new(user).remember
  end

  # Forces the user to login
  def force_login
    force_redirect_unless { logged_in? }
  end

  # Forces the user to be an admin
  def force_admin
    force_redirect_unless { admin? }
  end

  # Forces redirect unless the passed block returns true
  def force_redirect_unless(options={})
    unless yield
      redirect_to options[:page] || root_url
      flash[:danger] = options[:message] || 'You are not allowed to view that page'
    end
  end
end
