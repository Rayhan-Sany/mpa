class CurrentDateTimeReturnModel {
  static final String year = DateTime.now().year.toString();
  static final String month = currentMonthName();
  static final String day = DateTime.now().day.toString();
  static String currentMonthName() {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    int month = DateTime.now().month;
    print("${months[month - 1]} -------------");
    return months[month - 1];
  }

  static int currentWeekNumber() {
    int week = DateTime.now().day;
    if (week <= 7) {
      return 1;
    } else if (week > 7 && week <= 14) {
      return 2;
    } else if (week > 14 && week <= 21) {
      return 3;
    } else {
      return 4;
    }
  }
}
