
class MoreItem {
  String mItem1;
  String mItem2;
  bool mItem3;

  MoreItem({this.mItem1, this.mItem2, this.mItem3});

  MoreItem.fromJson(Map<String, dynamic> json) {
    mItem1 = json['m_Item1'] ?? '';
    mItem2 = json['m_Item2'] ?? '';
    mItem3 = json['m_Item3'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['m_Item1'] = this.mItem1;
    data['m_Item2'] = this.mItem2;
    data['m_Item3'] = this.mItem3;
    return data;
  }
}