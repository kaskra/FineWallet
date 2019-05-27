

int dayInMillis(DateTime time) {
  DateTime newDay = DateTime.utc(time.year, time.month, time.day, 12);
  return newDay.millisecondsSinceEpoch;
}

String getDayName(int day) {
  String dayName = "";
  switch (day) {
      case DateTime.monday:
        dayName = "Monday";
        break;
      case DateTime.tuesday:
        dayName = "Tuesday";
        break;
      case DateTime.wednesday:
        dayName = "Wednesday";
        break;
      case DateTime.thursday:
        dayName = "Thursday";
        break;
      case DateTime.friday:
        dayName = "Friday";
        break;
      case DateTime.saturday:
        dayName = "Saturday";
        break;
      case DateTime.sunday:
        dayName = "Sunday";
        break;
      default:
        dayName = "Today";
    }
  return dayName;
}

String getMonthName(int month, [bool abbrev]){
  List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  int index = month <= 0? 1 : month - 1;
  month > 12? index = 12 : index = month;
  return abbrev?months[index].substring(0,4) : months[index]; 
}

List<DateTime> getLastWeekAsDates() {
    List<DateTime> days = List();
    for (var i = 0; i < 7; i++) {
      DateTime lastDay = DateTime.now().add(Duration(days: -i));
      days.add(lastDay);
    }
    return days;
  }