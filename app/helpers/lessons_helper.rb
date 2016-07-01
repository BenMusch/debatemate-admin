module LessonsHelper

  def delete_or_redirect_home(object, success_message = "Deletion successful")
    error_message  = "An error occurred. Try again. See the link in the "
    error_message += "footer to report a bug if the problem persists"
    if object.destroy
      flash[:success] = success_message
    else
      flash[:danger] = error_message
    end
    redirect_to root_url
  end

  def row_name(lesson, mentor)
    names = mentor.admin? ? " (#{mentor_list(lesson)})" : ''
    mentor.to_s + names
  end

  def mentor_list(lesson)
    lesson.users.map(&:name).join(", ")
  end

end
