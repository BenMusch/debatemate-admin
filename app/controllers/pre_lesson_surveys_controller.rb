class PreLessonSurveysController < ApplicationController
  include SessionsHelper

  before_action :force_login
  before_action :set_surveys,              only: :index
  before_action :set_survey,               only: [:show, :edit]
  before_action :force_same_user_or_admin, only: :show
  before_action :force_same_user,          only: :edit

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def index
  end

  private

    # sets @lessons
    def set_surveys
      if admin?
        @surveys = PreLessonSurvey.all
      else
        @surveys = PreLessonSurvey.where(user_id: current_user.id)
      end
    end

    # sets @survey
    def set_survey
      @survey = PreLessonSurvey.find(params[:id])
    end

    # Forces the current_user to be logged in and either an admin or the user
    # whose profile is being shown
    def force_same_user_or_admin
      force_redirect_unless { admin? || (current_user && @survey) }
    end

    # Forces the current_user to be the user who submitted this survey
    def force_same_user
      force_redirect_unless { current_user.id = @survey.user_id }
    end
end
