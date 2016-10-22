class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    activator_service = UserActivatorService.new(user)
    if activator_service.activate(params[:id])
      log_in user
      flash[:success] = "Account activated!"
      redirect_to root_url
    else
      flash.now[:danger] = "Invalid activation link"
      render "new"
    end
  end

end
