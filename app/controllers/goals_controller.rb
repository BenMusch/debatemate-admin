class GoalsController < ApplicationController
  def update
    @goal = Goal.find(params[:id])
    if @goal.user_id == current_user.id
      if @goal.update_attributes(goal_params)
        flash[:success] = "Changes successful"
        redirect_to @goal.lesson
      else
        flash[:danger] = "Changes unsuccessful"
        render 'new'
      end
    else
      flash[:danger] = "You are not allowed to edit that goal"
      redirect_to @goal.lesson
    end
  end

  private

    def goal_params
      params.require(:goal).permit(:lesson_id, :user_id, :text)
    end
end
