class BannerModel {
  String alert;
  String img;
  String linkUrl;

  BannerModel({this.alert, this.img, this.linkUrl});

  BannerModel.fromJson(Map<String, dynamic> json) {
    alert = json['alert'];
    img = json['img'];
    linkUrl = json['linkUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alert'] = this.alert;
    data['img'] = this.img;
    data['linkUrl'] = this.linkUrl;
    return data;
  }
}