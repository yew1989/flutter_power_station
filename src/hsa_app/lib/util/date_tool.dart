import 'package:date_format/date_format.dart';

class DateTool {

  // 获取当天时间戳
  static String getTodayTimeStamp() {
    var now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    return formatDate(DateTime(year, month, day),[yyyy, '-', mm, '-', dd]) + ' 23:59:59';
  }

  // 获取上一周时间戳
  static String getLastWeekTimeStamp() {
    var now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final lastWeek = formatDate( DateTime(year, month, day).subtract(Duration(days: 6)),[yyyy, '-', mm, '-', dd]);
    return lastWeek + ' 00:00:00';
  }
}