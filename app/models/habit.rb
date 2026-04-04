class Habit < ApplicationRecord
  enum :completion_type, { step_by_step: 0, custom_value: 1 }
  enum :goal_type, { daily: 0, weekly: 1, monthly: 2 }

  has_one :habit_completion, dependent: :destroy

  validates :goal_type, presence: true
  validates :goal_amount, presence: true, if: -> { !daily? }

  before_validation :set_goal_amount_for_daily

  def cycle_completions(date, amount: 0)
    habit_completion = HabitCompletion.find_or_create_by(habit: self, completion_date: date) do |hc|
      hc.completion_amount = amount
    end

    case completion_type
    when "step_by_step"
      new_amount = completion_threshold < habit_completion.completion_amount + 1 ? 0 : habit_completion.completion_amount + 1
      habit_completion.update(completion_amount: new_amount)
    when "custom_value"
      habit_completion.update(completion_amount: amount)
    end
  end

  private

  def set_goal_amount_for_daily
    self.goal_amount = 1 if goal_type == "daily"
  end

  after_initialize do
    self.completion_type ||= 0
  end
end
