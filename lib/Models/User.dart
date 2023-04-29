import 'dart:math';
import 'dart:ui';
import 'package:uuid/uuid.dart';

import 'Game.dart';

class User{
  String _name;
  String _avatarUri;
  late String _chatAvatarUri;
  String? _friendCode;
  String _uuid;
  late bool isAlive;
  late String character;
  late String fakeCharacter;
  late int _seatNumber;

  int get seatNumber => _seatNumber;

  User(this._name, this._avatarUri):
    _uuid = new Uuid().v4();

  String get name => _name;


  String get charAvatarUri => _chatAvatarUri;


  set chatAvatarUri(String value) {
    _chatAvatarUri = value;
  }

  String get chatAvatarUri => _chatAvatarUri;

  String get avatarUri => _avatarUri;

  set avatarUri(String value) {
    _avatarUri = value;
  }

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
    _name = "",
    _avatarUri = "images/avatar.png",
    _uuid = "default uuid";


  void setCodeAndUuid(dynamic JSONData){
    // _friendCode = JSONData["friend_code"];
    _uuid = JSONData["uuid"];
  }

  bool equals(User? u){
    if(u==null) return false;
    return _uuid == u!._uuid;
  }

  bool isDefault(){
    return this.uuid == "default uuid";
  }

  bool isEvil(){
    return Game.evils.contains(this.character);
  }
}