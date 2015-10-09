module ApplicationHelper
  def page_title(title = '')
    if title.empty?
      "Debate Mate USA"
    else
      title + " | Debate Mate USA"
    end
  end

  def day_of_week_string(date)
    wday = date.wday
    case wday
    when 0
      "Sunday"
    when 1
      "Monday"
    when 2
      "Tuesday"
    when 3
      "Wednesday"
    when 4
      "Thursday"
    when 5
      "Friday"
    when 6
      "Saturday"
    else
      raise "lol wut is this date"
    end
  end
end
