import 'dart:convert';

class Words {
  String name;
  bool highlight;

  Words.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    highlight = json['highlight'];
  }
}
