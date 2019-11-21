class CloudFile {
  
  CloudCollection collection;
  CloudFile({this.collection});

  CloudFile.fromJson(Map<String, dynamic> json) {
    collection = json['collection'] != null
        ? CloudCollection.fromJson(json['collection'])
        : null;
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.collection != null) {
      data['collection'] = this.collection.toJson();
    }
    return data;
  }



}

class CloudCollection {
  List<String> stations;
  CloudCollection({this.stations});

  CloudCollection.fromJson(Map<String, dynamic> json) {
    stations = json['stations'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['stations'] = this.stations;
    return data;
  }
}

