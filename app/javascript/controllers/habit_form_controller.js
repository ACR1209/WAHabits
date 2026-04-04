import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["goalType", "goalAmount", "goalSuffix"];

  connect() {
    this.toggleGoalAmount();
    this.updateGoalSuffix();
  }

  toggleGoalAmount() {
    const goalType = this.goalTypeTarget.value;
    if (goalType === "daily") {
      this.goalAmountTarget.value = 1;
      this.goalAmountTarget.readOnly = true;
      this.goalAmountTarget.closest("div").style.display = "none";
    } else {
      this.goalAmountTarget.readOnly = false;
      this.goalAmountTarget.closest("div").style.display = "";
    }
  }

  updateGoalSuffix() {
    const goalType = this.goalTypeTarget.value;
    let suffix = "";
    if (goalType === "weekly") {
      suffix = "/week";
    } else if (goalType === "monthly") {
      suffix = "/month";
    }
    this.goalSuffixTarget.textContent = suffix;
  }

  changeGoalType() {
    this.toggleGoalAmount();
    this.updateGoalSuffix();
  }
}
