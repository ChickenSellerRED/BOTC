import 'dart:math';
import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


import 'Game.dart';

class User{
  String _name;
  String _avatarUri;
  late String _chatAvatarUri;
  String? _friendCode;
  String _uuid;
  bool isAlive = true;
  bool isPoison = false;
  bool canVote = true;
  bool isProtected = false;
  String character = "";
  late String fakeCharacter;
  late int _seatNumber;
  late String _reMark = "无";

  set reMark(String value) {
    _reMark = value;
  }

  String get reMark => _reMark;

  int get seatNumber => _seatNumber;

  set seatNumber(int value) {
    _seatNumber = value;
  }

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

  types.User? chatUser;
  void initChatUser(){
    chatUser = new types.User(id: uuid,imageUrl: chatAvatarUri,firstName: name,lastName: seatNumber==-1?"说书人":"(玩家 #${seatNumber})");
  }
  types.User toChatUser(){
    chatUser??initChatUser();
    return chatUser!;
}

}