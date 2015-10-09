class UserMailer < ApplicationMailer
  include ApplicationHelper
  # Mailer to activate accounts
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Mailer to reset passwords
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  # Reminds users to fill out their post-lesson surveys
  def survey_reminder(user)
    @user = user
    mail to: user.email, subject: "Reminder: Complete Post-Lesson Survey"
  end

  # Reminds users to go to their lesson
  def lesson_reminder(user)
    @user = user
    @lesson = user.next_lesson
    @school = @lesson.school.name
    @date   = @lesson.date.to_s
    mail to: user.email, subject: "Reminder: Lesson Scheduled Today"
  end

  # Reminds the user to do the pre-lesson surveys
  def pre_lesson_reminder(user)
    @day  = day_of_week_string(Date.tomorrow)
    @user = user
    mail to: user.email, subject: "Reminder: Complete Pre-Lesson Information"
  end
end
