// Old Version Code Don't use this
double buildDecisionThreeMethods(
  double a,
  double b,
) {
  double decisionTree(double p) {
    if (p < 60) {
      return 1;
    } else if (p < 70) {
      return 2;
    } else if (p < 80) {
      return 3;
    } else if (p < 90) {
      return 4;
    } else {
      return 5;
    }
  }

  double c(double a, double b) {
    double p = (a / b) * 100;

    if (p < 50) {
      return 0;
    } else {
      return decisionTree(p);
    }
  }

  double l = c(a, b);
  return l;
}
