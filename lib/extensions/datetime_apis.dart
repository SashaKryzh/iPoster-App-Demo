extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isThisWeek() {
    final now = DateTime.now();
    return now.difference(this).inDays < 7 && this.weekday <= now.weekday;
  }

  bool isThisYear() {
    final now = DateTime.now();
    return now.year == this.year;
  }
}
