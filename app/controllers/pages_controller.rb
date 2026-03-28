class PagesController < ApplicationController
  def index
    @reminders = Reminder.all
  end
end
