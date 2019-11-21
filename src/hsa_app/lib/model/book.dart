import 'dart:convert';

class Book {

  String name;
  String img;
  String demoUrl;
  
  Book(this.name, this.img, this.demoUrl);
  
    Book.fromJson(String jsonStr){
    var map = json.decode(jsonStr);
    name = map['name'] ?? '';
    img = map['img'] ?? '';
    demoUrl = map['demoUrl'] ?? '';
  }

  String toJson(){
    var rawJson = {
      'name':name ?? '',
      'img':img ?? '',
      'demoUrl':demoUrl ?? '',
    };
    var jsonStr = json.encode(rawJson);
    return jsonStr ?? '';
  }


}

class BookData {
  List<Book> books;
  BookData({this.books});

  BookData.fromJson(String jsonStr) {
    var str = jsonStr;
    if(str == null) {
      str = '{"books":[]}';
    }
    var map = json.decode(str);
    if (map['books'] != null) {
      books =  List<Book>();
      map['books'].forEach((v) {
        books.add( Book.fromJson(v));
      });
    }
  }

  String toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    if (this.books != null) {
      map['books'] = this.books.map((v) => v.toJson()).toList();
    }
    var jsonStr = json.encode(map);
    return jsonStr ?? '';
  }

}