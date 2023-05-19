import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../common/Global.dart';
import 'User.dart';

class ChatRoom{
  final List<types.Message> _messages;

  List<types.Message> get messages => _messages;
  final int _chatRoomNumber;

  int get chatRoomNumber => _chatRoomNumber;
  final bool _isSingle;
  late List<User>? chatUsers;
  late User? chatUser;
  final String name;

  final types.User _user;

  ChatRoom(this._chatRoomNumber,this._messages, this._isSingle,this.name,this._user,{this.chatUsers,this.chatUser});

  String generateChatAvatarUri(){
    if(!_isSingle)
      return "images/evil_chat_avatar.png";
    else return chatUser!.chatAvatarUri;
  }

  void addMessage(types.PartialText message){
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _messages.insert(0,textMessage);
    _send({
        "verb":"send_chat_message",
        "body":{
          "chat_room_number":this._chatRoomNumber,//-1:说书人,-2:邪恶阵营,>0:玩家座位号
          "from_seat_number":Global.userProfile.seatNumber,
          "message":message.text
        }
      });
  }

  void addOuterMessage(User sender, String message){
    final textMessage = types.TextMessage(
      author: sender.toChatUser(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message,
    );
    _messages.insert(0,textMessage);
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _send(dynamic data){
    Global.channel.sink.add(jsonEncode(data));
  }
}