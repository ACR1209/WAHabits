json.extract! habit, :id, :title, :description, :completion_type, :completion_threshold, :goal_type, :goal_amount, :created_at, :updated_at
json.url habit_url(habit, format: :json)
