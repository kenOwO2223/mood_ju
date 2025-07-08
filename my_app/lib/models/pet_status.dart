class PetStatus {
  int intimacyLevel; // 以等級方式呈現，例如 Lv.1 ~ Lv.10
  int hunger;        // 0~100
  int activity;      // 0~100

  PetStatus({
    this.intimacyLevel = 1,
    this.hunger = 100,
    this.activity = 100,
  });

  void decreaseHunger(int amount) {
    hunger = (hunger - amount).clamp(0, 100);
  }

  void decreaseActivity(int amount) {
    activity = (activity - amount).clamp(0, 100);
  }

  void increaseIntimacy() {
    if (intimacyLevel < 10) {
      intimacyLevel++;
    }
  }
}
