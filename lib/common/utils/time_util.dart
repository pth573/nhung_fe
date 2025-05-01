import 'package:intl/intl.dart';

class TimeUtil {
  static String getTime(DateTime now) {
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }

  static String timestampToDateTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  static String epochToVietnamTime(int epochTimeMillis) {
    // Chuyển epochTime (milisecond) sang DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTimeMillis).toLocal();

    // Định dạng ngày giờ kiểu Việt Nam
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  static String calcTotalTime(int startTime, int endTime) {
    // Chuyển epochTime (milisecond) sang DateTime
    DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime).toLocal();
    DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(endTime).toLocal();

    // Tính tổng thời gian
    Duration duration = endDateTime.difference(startDateTime);

    // Chuyển Duration thành chuỗi dạng 'giờ:phút:giây'
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return '$hours giờ $minutes phút $seconds giây';
  }


}