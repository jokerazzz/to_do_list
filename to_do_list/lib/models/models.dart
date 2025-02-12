class Task {
  String title;
  bool isCompleted;
  DateTime? deadline;
  DateTime? completionDate;
  String category;
  Task(
      {required this.title,
      this.deadline,
      this.isCompleted = false,
      this.completionDate,
      required this.category});
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
