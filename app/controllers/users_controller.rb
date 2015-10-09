class UsersController < ApplicationController
  before_action :force_same_user_or_admin, only: :show
  before_action :force_admin,              only: [:index, :set_days]

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
    @users = User.mentor.order(:name)
  end

  def set_days
    @users = User.mentor.order(:name)
  end

  def update_days
    User.all.each do |user|
      id_key = user.id.to_s
      days = params["days"][id_key]
      if days
        user.update_attribute(:monday,    days["monday"]    == "true")
        user.update_attribute(:tuesday,   days["tuesday"]   == "true")
        user.update_attribute(:wednesday, days["wednesday"] == "true")
        user.update_attribute(:thursday,  days["thursday"]  == "true")
        user.update_attribute(:friday,    days["friday"]    == "true")
      end
    end
    flash[:success] = "Days updated"
    redirect_to root_url
  end

  private

    def user_params
      params[:admin] = params[:admin] == '1'
      params.require(:user).permit(:password, :password_confirmation,
                                   :name,     :email,
                                   :admin,    :monday,
                                   :tuesday,  :wednesday,
                                   :thursday, :friday,
                                   :phone)
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
