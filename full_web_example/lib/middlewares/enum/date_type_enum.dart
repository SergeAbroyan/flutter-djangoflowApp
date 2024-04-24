enum DateType {
  today,
  yesterday,
  lastWeek,
  lastTwoWeeks,
  lastMonth,
  last_3Months
}

extension DateTypeExtension on DateType {
  String get title {
    switch (this) {
      case DateType.today:
        return 'Today';
      case DateType.yesterday:
        return 'Yesterday';
      case DateType.lastWeek:
        return 'Last Week';
      case DateType.lastTwoWeeks:
        return 'Last 2 Weeks';
      case DateType.lastMonth:
        return 'Last Month';
      case DateType.last_3Months:
        return 'Last 3 Months';
    }
  }

  DateTime dateTime() {
    final now = DateTime.now();
    final onlyDate = DateTime(now.year, now.month, now.day);
    switch (this) {
      case DateType.last_3Months:
        return onlyDate.subtract(const Duration(days: 90));
      case DateType.today:
        return onlyDate;
      case DateType.yesterday:
        return onlyDate.subtract(const Duration(days: 1));
      case DateType.lastWeek:
        return onlyDate.subtract(const Duration(days: 7));
      case DateType.lastTwoWeeks:
        return onlyDate.subtract(const Duration(days: 14));
      case DateType.lastMonth:
        return onlyDate.subtract(const Duration(days: 31));
    }
  }
}
