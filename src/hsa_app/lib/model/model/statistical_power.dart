class StatisticalPower{
  int day;
  int month;
  int year;
  int power;

  StatisticalPower({this.day,this.month,this.power});

  StatisticalPower.fromJson(Map<String, dynamic> json) {
    day = changeDay(json['freezeTime']);
    month = changeMonth(json['freezeTime']);
    power = json['总正向有功电能'] ?? 0;
  }

  StatisticalPower.fromJsonMonth(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    power = json['monthlyElectric'] ?? 0;
  }

  changeDay(String date){

    DateTime startDate = DateTime.parse(date);

    return startDate.day;
  }

  changeMonth(String date){
    
    DateTime startDate = DateTime.parse(date);

    return startDate.month;
  }




} 