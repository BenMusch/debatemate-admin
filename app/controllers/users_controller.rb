class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params[:admin] = params[:admin] == '1'
      params.require(:user).permit(:password,
                                   :password_confirmation,
                                   :name,
                                   :email,
                                   :admin)
    end
end
