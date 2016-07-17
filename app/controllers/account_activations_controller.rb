class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    activator_service = UserActivatorService.new(user)
    if activator_service.activate(params[:id])
      log_in user
      flash[:success] = "Account activated!"
    else
      flash[:danger] = "Invalid activation link"
    end
    redirect_to root_url
  end

end
