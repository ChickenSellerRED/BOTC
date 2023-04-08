import 'dart:convert';

class Tools{
  static Map json2Map(dynamic event){
    return jsonDecode(event as String);
  }
}