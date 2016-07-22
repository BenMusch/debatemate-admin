module ApplicationHelper
  DAYS_OF_WEEK = {
    0 => "Sunday",
    1 => "Monday",
    2 => "Tuesday",
    3 => "Wednesday",
    4 => "Thursday",
    5 => "Friday",
    6 => "Saturday"
  }

  def page_title(title = '')
    if title.empty?
      "Debate Mate USA"
    else
      title + " | Debate Mate USA"
    end
  end

  def day_of_week_string(date)
    DAYS_OF_WEEK[date.wday]
  end
end
