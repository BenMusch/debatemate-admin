class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    activator = UserActivatorService.new(user)
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      activator.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
