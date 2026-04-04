class PagesController < ApplicationController
  def index
    @reminders = Reminder.all.order(:due)
    @habits = Habit.all.order(:created_at)
  end
end
