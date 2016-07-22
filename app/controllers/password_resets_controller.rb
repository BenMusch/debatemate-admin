class PasswordResetsController < ApplicationController
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    if user && reset_service.begin
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "No user found with that email"
      render 'new'
    end
  end

  def edit
    if reset_service.expired?
      flash.now[:danger] = "Reset link expired. Please reset your password again."
      render "new"
    else
      render "edit"
    end
  end

  def update
    if user.update_attributes user_params
      log_in user
      flash[:success] = "Password has been reset"
      redirect_to user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user
    @user ||= User.where(email: email).first
  end

  def email
    params[:password_reset] ? params[:password_reset][:email] : params[:email]
  end

  def reset_service
    @reset_service ||= PasswordResetService.new(user)
  end

  def valid_user
    unless reset_service.authenticated?(params[:id])
      flash[:danger] = "Invalid reset link"
      redirect_to root_url
    end
  end
end
