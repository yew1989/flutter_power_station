class BannerResponse {
  int code;
  int http;
  String msg;
  BannerData data;

  BannerResponse({this.code, this.http, this.msg, this.data});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    http = json['http'];
    msg = json['msg'];
    data = json['data'] != null ? BannerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['http'] = this.http;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class BannerData {
  List<BannerItem> banner;

  BannerData({this.banner});

  BannerData.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = List<BannerItem>();
      json['banner'].forEach((v) {
        banner.add(BannerItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerItem {
  String img;
  String link;

  BannerItem({this.img, this.link});

  BannerItem.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['img'] = this.img;
    data['link'] = this.link;
    return data;
  }
}