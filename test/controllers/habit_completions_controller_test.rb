require "test_helper"

class HabitCompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @habit_completion = habit_completions(:one)
  end

  test "should get index" do
    get habit_completions_url
    assert_response :success
  end

  test "should get new" do
    get new_habit_completion_url
    assert_response :success
  end

  test "should create habit_completion" do
    assert_difference("HabitCompletion.count") do
      post habit_completions_url, params: { habit_completion: { completion_date: @habit_completion.completion_date, goal_amount: @habit_completion.goal_amount, goal_type: @habit_completion.goal_type, habit_id: @habit_completion.habit_id } }
    end

    assert_redirected_to habit_completion_url(HabitCompletion.last)
  end

  test "should show habit_completion" do
    get habit_completion_url(@habit_completion)
    assert_response :success
  end

  test "should get edit" do
    get edit_habit_completion_url(@habit_completion)
    assert_response :success
  end

  test "should update habit_completion" do
    patch habit_completion_url(@habit_completion), params: { habit_completion: { completion_date: @habit_completion.completion_date, goal_amount: @habit_completion.goal_amount, goal_type: @habit_completion.goal_type, habit_id: @habit_completion.habit_id } }
    assert_redirected_to habit_completion_url(@habit_completion)
  end

  test "should destroy habit_completion" do
    assert_difference("HabitCompletion.count", -1) do
      delete habit_completion_url(@habit_completion)
    end

    assert_redirected_to habit_completions_url
  end
end
