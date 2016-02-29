class MentorNotificationPolicy
  attr_accessor :mentor

  def initialize(mentor)
    @mentor = mentor
  end

  # Checks reminders and sends any necessary reminders
  def remind
    # if the lesson is in a day and they haven't done the pre-lesson
    if lesson_tomorrow? && next_lesson.date != Date.tomorrow
      send_pre_lesson_reminder_email
    elsif Date.today == next_lesson.date
      send_lesson_reminder_email
    # if there was a lesson scheduled yesterday and no post-lesson survey was filled out
    #elsif previous_lesson.unfinished?
    # # remind the user to do the post lesson survey
    end
  end

  private

  def next_lesson
    mentor.lessons.upcoming.first
  end

  def previous_lesson
    mentor.lessons.completed.first
  end
  # does the user usually have a lesson tomorrow?
  def lesson_tomorrow?
    return false if Date.tomorrow.saturday? || Date.tomorrow.sunday?
    self.send("#{Date.tomorrow.strftime('%A').downcase}?")
  end

  # Sends the lesson reminder email
  def send_lesson_reminder_email
    UserMailer.lesson_reminder(self).deliver_now
  end

  # Sends the pre_lesson reminder email
  def send_pre_lesson_reminder_email
    UserMailer.lesson_reminder(self).deliver_now
  end
end
