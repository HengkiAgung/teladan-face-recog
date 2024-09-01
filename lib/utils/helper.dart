String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
    ? myString
    : '${myString.substring(0, cutoff)}...';
}

String formatHourTime(String time, int gmt) {
  if (time == "") {
    return "";
  }
  DateTime dateCheckIn = DateTime.parse("2022-10-10 $time");
  dateCheckIn = dateCheckIn.subtract(Duration(hours: gmt*-1));
  // Use padLeft to add leading zeros
  String formattedHour = dateCheckIn.hour.toString().padLeft(2, '0');
  String formattedMinute = dateCheckIn.minute.toString().padLeft(2, '0');
  
  return "$formattedHour:$formattedMinute";
}

String formatDateToHourTime(String time, int gmt) {
  if (time == "") {
    return "";
  }
  DateTime dateCheckIn = DateTime.parse(time);
  dateCheckIn = dateCheckIn.subtract(Duration(hours: gmt *-1));
  // Use padLeft to add leading zeros
  String formattedHour = dateCheckIn.hour.toString().padLeft(2, '0');
  String formattedMinute = dateCheckIn.minute.toString().padLeft(2, '0');
  
  return "$formattedHour:$formattedMinute";
}

String formatDateTime(String time, int gmt) {
  if (time == "") {
    return "";
  }
  DateTime dateCheckIn = DateTime.parse(time);
  dateCheckIn = dateCheckIn.subtract(Duration(hours: gmt*-1));
  String formattedHour = dateCheckIn.hour.toString().padLeft(2, '0');
  String formattedMinute = dateCheckIn.minute.toString().padLeft(2, '0');

  return "${dateCheckIn.year}-${dateCheckIn.month}-${dateCheckIn.day} $formattedHour:$formattedMinute";
}

String formatDate(String time, int gmt) {
  if (time == "") {
    return "";
  }
  DateTime dateCheckIn = DateTime.parse(time);
  dateCheckIn = dateCheckIn.subtract(Duration(hours: gmt*-1));

  return "${dateCheckIn.year}-${dateCheckIn.month}-${dateCheckIn.day}";
}