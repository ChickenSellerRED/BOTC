import 'dart:math';
import 'dart:ui';
import 'package:uuid/uuid.dart';

class User{
  String _name;
  String _avatarUri;
  String? _friendCode;
  String? _uuid;

  User(this._name, this._avatarUri){
    // _friendCode = Random().nextInt(100000000).toString();
    _uuid = new Uuid().v4();
    print(_uuid);
  }

  String get name => _name;

  Map<String,dynamic> toHeader(){
    Map<String,dynamic> ans = {"name":_name,"avatar_uri":_avatarUri,
      // "friend_code":_friendCode,
      "uuid":_uuid
    };
    return ans;
  }

  static User buildFromJSON(dynamic JSONData){
    User ans = new User(JSONData["name"],JSONData["avatar_uri"]);
    ans.setCodeAndUuid(JSONData);
    return ans;
  }

  void setCodeAndUuid(dynamic JSONData){
    // _friendCode = JSONData["friend_code"];
    _uuid = JSONData["uuid"];
  }

  bool equals(User u){
    return _uuid == u._uuid;
  }
}