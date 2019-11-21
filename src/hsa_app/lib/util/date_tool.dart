class DateTool {

  static String dnetDateToDart(String dnetDate) {
    var dartString = dnetDate.replaceFirst(RegExp(r'T'), ' ');
    var array = dartString.split('.');
    return array.first;
  }
}