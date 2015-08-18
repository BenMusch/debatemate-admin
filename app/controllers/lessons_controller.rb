class LessonsController < ApplicationController
  include SessionsHelper
  before_action :force_admin,              only: :index
  before_action :force_same_user_or_admin, only: :show
  before_action :set_lesson

  def index
  end

  def show
  end

  private

    # Sets @lesson
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Forces the current_user to be logged in and either an admin or the user
    # whose profile is being shown
    def force_same_user_or_admin
      force_redirect_unless do
        admin? || (current_user && @lesson.given_by?(current_user))
      end
    end
end
