class Task {
  String title;
  bool isCompleted;
  DateTime deadline;
  DateTime? completionDate;
  Task({
    required this.title,
    required this.deadline,
    this.isCompleted = false,
    this.completionDate,
  });
}

String formatDateTime(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String day = twoDigits(dateTime.day);
  String month = twoDigits(dateTime.month);
  String year = dateTime.year.toString();
  String hour = twoDigits(dateTime.hour);
  String minute = twoDigits(dateTime.minute);

  return "$day.$month.$year $hour:$minute";
}
