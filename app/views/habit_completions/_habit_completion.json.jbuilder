json.extract! habit_completion, :id, :habit_id, :completion_date, :goal_type, :goal_amount, :created_at, :updated_at
json.url habit_completion_url(habit_completion, format: :json)
