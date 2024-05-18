int buildDecisionThreeMethods(
  int maxHr,
  int hr,
) {
  int decisionTree(double percentage) {
    if (percentage < 60) {
      return 1; // Level 1
    } else if (percentage < 70) {
      return 2; // Level 2
    } else if (percentage < 80) {
      return 3; // Level 3
    } else if (percentage < 90) {
      return 4; // Level 4
    } else {
      return 5; // Level 5
    }
  }

  int calculateLevel(int hr, int max) {
    double percentage = (hr / max) * 100;

    if (percentage < 50) {
      return 0; // Heart rate below 50% of MaxHR
    } else {
      return decisionTree(percentage);
    }
  }

  int level = calculateLevel(hr, maxHr);
  return level;
}
