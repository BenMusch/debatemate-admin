module LessonsHelper
  def delete_or_redirect_home(object, success_message = "Deletion successful")
    error_message  = "An error occurred. Try again. See the link in the "
    error_message += "footer to report a bug if the problem persists"
    if object.destroy
      flash[:success] = success_message
      redirect_to root_url
    else
      flash[:danger] = error_message
      redirect_to root_url
    end
  end
end
