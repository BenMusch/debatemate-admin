class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Account created!"
      redirect_to @user
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
