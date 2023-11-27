String timeConverted({required String time}) {
  DateTime utcDateTime = DateTime.parse(time);
  DateTime indianDateTime =
      utcDateTime.add(const Duration(hours: 5, minutes: 30));

  int hour = indianDateTime.hour % 12;
  String formattedHour = (hour == 0) ? '12' : '$hour';
  String formattedTime =
      '${_formatTwoDigits(int.parse(formattedHour))}:${_formatTwoDigits(indianDateTime.minute)} ${indianDateTime.hour < 12 ? 'AM' : 'PM'}';

  return formattedTime;
}

String _formatTwoDigits(int n) {
  return n < 10 ? '0$n' : '$n';
}
