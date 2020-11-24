import 'dart:convert';

class Words {
  String name;
  bool highlight;


  Words(String name,bool highlight){
    this.name = name;
    this.highlight = highlight;
  }

  Words.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    highlight = json['highlight'];
  }
}
