double scale = 1.0;

extension DoubleExtension on double {
  double get dynamic {
    return this * scale;
  }
}

extension IntExtension on int {
  double get dynamic {
    return (this.toDouble() * scale);
  }
}
