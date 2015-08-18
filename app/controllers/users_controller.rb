class UsersController < ApplicationController
  before_action :force_same_user_or_admin, only: :show
  before_action :force_admin,              only: :index

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
    puts @user.name
    render 'show'
  end

  def index
    @users = User.where(admin: false)
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

    # Forces the current_user to be logged in and either an admin or the user
    # whose profile is being shown
    def force_same_user_or_admin
      unless admin? || (current_user && current_user.id == params[:id])
        if logged_in?
          message = "You cannot view other users' profiles"
        else
          message = "You must be logged in to view this page"
        end
        flash[:danger] = message
        redirect_to root_url
      end
    end
end
