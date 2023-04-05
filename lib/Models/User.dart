import 'dart:math';
import 'dart:ui';
import 'package:uuid/uuid.dart';

class User{
  String _name;
  String _avatarUri;
  String? _friendCode;
  String _uuid;

  User(this._name, this._avatarUri):
    _uuid = new Uuid().v4();

  String get name => _name;


  String get uuid => _uuid;

  Map<String,dynamic> toHeader(){
    Map<String,dynamic> ans = {"name":_name,"avatar_uri":_avatarUri,
      // "friend_code":_friendCode,
      "uuid":_uuid
    };
    return ans;
  }

  User.buildFromJSON(dynamic json):
    _name = json["name"],
    _avatarUri = json["avatar_uri"],
    _uuid = json["uuid"];

  User.buildDefault():
    _name = "     ",
    _avatarUri = "images/avatar.png",
    _uuid = "default uuid";


  void setCodeAndUuid(dynamic JSONData){
    // _friendCode = JSONData["friend_code"];
    _uuid = JSONData["uuid"];
  }

  bool equals(User u){
    return _uuid == u._uuid;
  }
}