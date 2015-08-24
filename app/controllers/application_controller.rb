class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def index
    redirect_to lessons_path if logged_in?
    @user = User.new
  end
end
