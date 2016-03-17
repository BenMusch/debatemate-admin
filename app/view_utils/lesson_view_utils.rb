module LessonViewUtils
  def mentor_list
    users.map(&:name).join(", ")
  end

  def row_name(admin)
    names = admin ? " (#{mentor_list})" : ''
    to_s + names
  end
end
