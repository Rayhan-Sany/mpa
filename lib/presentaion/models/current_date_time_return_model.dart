class CurrentDateTimeReturnModel {
  static final String year = DateTime.now().year.toString();
  static final String month = currentMonthName();
  static final String day = DateTime.now().day.toString();
  static currentMonthName() {
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
}
