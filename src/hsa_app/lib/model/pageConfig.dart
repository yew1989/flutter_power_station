class PageConfig {
  AppPageRoute appPageRoute;

  PageConfig({this.appPageRoute});

  PageConfig.fromJson(Map<String, dynamic> json) {
    appPageRoute = json['AppPageRoute'] != null
        ? AppPageRoute.fromJson(json['AppPageRoute'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.appPageRoute != null) {
      data['AppPageRoute'] = this.appPageRoute.toJson();
    }
    return data;
  }
}

class AppPageRoute {
  String verison;
  String host;
  String devHost;
  String prdHost;
  String testHost;
  PageBundle page;

  AppPageRoute(
      {this.verison,
      this.host,
      this.devHost,
      this.prdHost,
      this.testHost,
      this.page});

  AppPageRoute.fromJson(Map<String, dynamic> json) {
    verison = json['verison'];
    host = json['host'];
    devHost = json['devHost'];
    prdHost = json['prdHost'];
    testHost = json['testHost'];
    page = json['page'] != null ? PageBundle.fromJson(json['page']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['verison'] = this.verison;
    data['host'] = this.host;
    data['devHost'] = this.devHost;
    data['prdHost'] = this.prdHost;
    data['testHost'] = this.testHost;
    if (this.page != null) {
      data['page'] = this.page.toJson();
    }
    return data;
  }
}

class PageBundle {
  PageItem banner;
  PageItem credits;
  PageItem clockin;
  PageItem about;
  PageItem mypowerchart;
  PageItem history;
  PageItem video;

  PageBundle(
      {this.banner,
      this.credits,
      this.clockin,
      this.about,
      this.mypowerchart,
      this.history,
      this.video});

  PageBundle.fromJson(Map<String, dynamic> json) {
    banner =
        json['banner'] != null ? PageItem.fromJson(json['banner']) : null;
    credits =
        json['credits'] != null ? PageItem.fromJson(json['credits']) : null;
    clockin =
        json['clockin'] != null ? PageItem.fromJson(json['clockin']) : null;
    about = json['about'] != null ? PageItem.fromJson(json['about']) : null;
    mypowerchart = json['mypowerchart'] != null
        ? PageItem.fromJson(json['mypowerchart'])
        : null;
    history =
        json['history'] != null ? PageItem.fromJson(json['history']) : null;
    video = json['video'] != null ? PageItem.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    if (this.credits != null) {
      data['credits'] = this.credits.toJson();
    }
    if (this.clockin != null) {
      data['clockin'] = this.clockin.toJson();
    }
    if (this.about != null) {
      data['about'] = this.about.toJson();
    }
    if (this.mypowerchart != null) {
      data['mypowerchart'] = this.mypowerchart.toJson();
    }
    if (this.history != null) {
      data['history'] = this.history.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    return data;
  }
}

class PageItem {
  String title;
  String desc;
  bool isFullScreen;
  String route;

  PageItem({this.title, this.desc, this.isFullScreen, this.route});

  PageItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    isFullScreen = json['isFullScreen'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['isFullScreen'] = this.isFullScreen;
    data['route'] = this.route;
    return data;
  }
}