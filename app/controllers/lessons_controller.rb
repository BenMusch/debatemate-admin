class LessonsController < ApplicationController
  include LessonsHelper
  include SessionsHelper
  before_action :force_login
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
      flash[:danger]  = "You have already created a lesson on the same day "
      flash[:danger] += "at the same school"
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
    admin? ? lessons = Lesson.all : lessons = current_user.lessons
    @upcoming_lessons  = lessons.upcoming
    @completed_lessons = lessons.order(date: 'desc').completed
  end

  def update
    @lesson = Lesson.find(lesson_params[:id])
    if @lesson.update_attributes(lesson_params)
      flash[:success] = "Changes successful"
      if @lesson.users.any?
        @lesson.delete_goals
        redirect_to @lesson
      else
        @lesson.destroy
        flash[:info] = "No other mentors for that lesson. Lesson deleted."
        redirect_to root_path
      end
    else
      flash[:danger] = "Changes unsuccessful. See the link in the footer to"
      flash[:danger] += "contact the developer if problems persist"
      redirect_to @lesson
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @message =  "Are you sure? Only do this if you and the other "
    @message += "mentors in this lesson are chaning the date. Otherwise, remove"
    @message += " yourself from this lesson and create a new one."
  end

  private

    # Forces the current_user to be logged in and either an admin or the user
    # whose profile is being shown
    def force_same_user_or_admin
      @lesson = Lesson.find(params[:id])
      force_redirect_unless do
        admin? || (current_user && @lesson.given_by?(current_user))
      end
    end

    # strong params
    def lesson_params
      params.require(:lesson).permit(:id, :school_id, :date, :user_id,
                                     goals_attributes: [:id, :text,
                                                        :lesson_id, :user_id])
    end

    # Finds a lesson with the same date and school, or creates the lesson
    def find_or_initialize_lesson
      @lesson = Lesson.find_or_initialize_by(
        date: lesson_params[:date],
        school_id: lesson_params[:school_id]
      )
    end
end
