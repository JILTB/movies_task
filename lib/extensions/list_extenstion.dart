extension CalculateRatingExtension on List<int> {
  double calculateUserRating() {
    if (isEmpty) return 0;
    return (reduce((a, b) => a + b) / length);
  }
}
