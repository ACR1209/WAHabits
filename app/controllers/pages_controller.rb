class PagesController < ApplicationController
  def index
    @reminders = Reminder.all.order(:due)
  end
end
