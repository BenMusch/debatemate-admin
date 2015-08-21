class LessonsController < ApplicationController
  include LessonsHelper
  include SessionsHelper
  before_action :force_login
  before_action :force_admin,              only: :index
  before_action :force_same_user_or_admin, only: :show

  def new
    @user   = current_user
    @lesson = Lesson.new
    @lesson.goals.build
    @school_options = School.all.map { |s| [s.name, s.id] }
  end

  def create
    find_or_initialize_lesson
    if !@lesson.new_record? && @lesson.given_by?(current_user)
      flash[:danger] = "You have already created a lesson on the same day at the same school"
      redirect_to @lesson
      return
    end
    goal = Goal.new(lesson_params[:goals_attributes]['0'])
    @lesson.goals << goal
    if @lesson.save
      flash[:success] = "Response logged"
      redirect_to @lesson
    else
      @user = current_user
      @school_options = School.all.map { |s| [s.name, s.id] }
      render 'new'
    end
  end

  def index
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(lesson_params)
      flash[:success] = "Changes successful"
    else
      flash[:dander] = "Changes unsuccessful. See the link in the footer to"
      flash[:danger] += "contact the developer if problems persist"
    end
    redirect_to @lesson
  end

  def remove_user
    @lesson = Lesson.find(params[:id])
    if !@lesson.given_by?(current_user)
      error_message  = "An error occurred. Try again. See the link in the "
      error_message += "footer to report a bug if the problem persists"
      flash[:danger] = error_message
      redirect_to root_url
    elsif @lesson.users.count == 1
      delete_or_redirect_home @lesson, "Lesson deleted"
    else
      goal = Goal.find_by(lesson_id: @lesson.id, user_id: current_user.id)
      delete_or_redirect_home goal, "Successfully removed from lesson"
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @message = "Are you sure? Only do this if you and the other"
    @message += " mentors in this lesson are chaning the date. Otherwise, remove"
    @message += " yourself from this lesson and create a new one."
  end

  private

    # Forces the current_user to be logged in and either an admin or the user
    # whose profile is being shown
    def force_same_user_or_admin
      @lesson = Lesson.find_by(params[:id])
      force_redirect_unless do
        admin? || (current_user && @lesson.given_by?(current_user))
      end
    end

    # strong params
    def lesson_params
      params.require(:lesson).permit(:school_id, :date,
                                     goals_attributes: [:id, :user_id,
                                                        :text, :lesson_id])
    end

    # Finds a lesson with the same date and school, or creates the lesson
    def find_or_initialize_lesson
      @lesson = Lesson.find_or_initialize_by(
        date: lesson_params[:date],
        school_id: lesson_params[:school_id]
      )
    end
end
