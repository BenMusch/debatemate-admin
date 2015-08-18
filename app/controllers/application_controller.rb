class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def index
    render 'admin_home_page' if admin?
    render 'user_home_page'  if logged_in? && !admin?
    @user = User.new         unless logged_in?
  end
end
