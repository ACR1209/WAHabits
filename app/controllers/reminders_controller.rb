class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[ show edit update destroy ]

  # GET /reminders or /reminders.json
  def index
    @reminders = Reminder.all
  end

  # GET /reminders/1 or /reminders/1.json
  def show
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
  end

  # GET /reminders/1/edit
  def edit
  end

  # POST /reminders or /reminders.json
  def create
    @reminder = Reminder.new(reminder_params)

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to @reminder, notice: "Reminder was successfully created." }
        format.json { render :show, status: :created, location: @reminder }
        format.turbo_stream {
          @reminders = Reminder.all
          render "reminders/create_success"
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
        format.turbo_stream {
          render "reminders/create_failure"
        }
      end
    end
  end

  # PATCH/PUT /reminders/1 or /reminders/1.json
  def update
    respond_to do |format|
      if @reminder.update(reminder_params)
        format.html { redirect_to @reminder, notice: "Reminder was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @reminder }
        format.turbo_stream do
          render "reminders/update_success"
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1 or /reminders/1.json
  def destroy
    @reminder.destroy!

    respond_to do |format|
      format.html { redirect_to reminders_path, notice: "Reminder was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reminder
      @reminder = Reminder.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reminder_params
      params.expect(reminder: [ :title, :description, :due, :done ])
    end
end
