module ApplicationHelper
  def page_title(title = '')
    if title.empty?
      "Debate Mate USA"
    else
      title + " | Debate Mate USA"
    end
  end
end
