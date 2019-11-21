class Echart {
  String func;
  String action;
  List<Data> data;

  Echart({this.func, this.action, this.data});

  Echart.fromJson(Map<String, dynamic> json) {
    func = json['func'];
    action = json['action'];
    if (json['data'] != null) {
      data = List<Data>();
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['func'] = this.func;
    data['action'] = this.action;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int value;
  String name;

  Data({this.value, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}