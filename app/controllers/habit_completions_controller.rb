class HabitCompletionsController < ApplicationController
  before_action :set_habit_completion, only: %i[ show edit update destroy ]

  # GET /habit_completions or /habit_completions.json
  def index
    @habit_completions = HabitCompletion.all
  end

  # GET /habit_completions/1 or /habit_completions/1.json
  def show
  end

  # GET /habit_completions/new
  def new
    @habit_completion = HabitCompletion.new
  end

  # GET /habit_completions/1/edit
  def edit
  end

  # POST /habit_completions or /habit_completions.json
  def create
    @habit_completion = HabitCompletion.new(habit_completion_params)

    respond_to do |format|
      if @habit_completion.save
        format.html { redirect_to @habit_completion, notice: "Habit completion was successfully created." }
        format.json { render :show, status: :created, location: @habit_completion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @habit_completion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /habit_completions/1 or /habit_completions/1.json
  def update
    respond_to do |format|
      if @habit_completion.update(habit_completion_params)
        format.html { redirect_to @habit_completion, notice: "Habit completion was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @habit_completion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @habit_completion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /habit_completions/1 or /habit_completions/1.json
  def destroy
    @habit_completion.destroy!

    respond_to do |format|
      format.html { redirect_to habit_completions_path, notice: "Habit completion was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit_completion
      @habit_completion = HabitCompletion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def habit_completion_params
      params.expect(habit_completion: [ :habit_id, :completion_date, :goal_type, :goal_amount ])
    end
end
