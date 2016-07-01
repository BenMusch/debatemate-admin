class SchoolsController < ApplicationController
  include SessionsHelper
  before_action :force_admin

  def index
    @school = School.new
    @schools = School.all.order(:name.asc)
  end

  def show
    @school = School.find(params[:id])
  end

  def update
    @school = school.find(params[:id])
    if @school.update_attributes(school_params)
      flash[:success] = "Changes successful"
    else
      flash[:danger] = "Changes unsuccessful. See the link in the footer to "
      flash[:danger] += "contact the developer if problems persist"
    end
    redirect_to @school
  end

  def create
    @school = School.new(school_params)
    if @school.save
      flash[:success] = "School added"
      redirect_to schools_path
    else
      @schools = School.all
      render 'index'
    end
  end

  private

    # strong parameters
    def school_params
      params.require(:school).permit(:name)
    end
end
