import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../common/Global.dart';
import 'User.dart';

class ChatRoom{
  final List<types.Message> _messages;
  final Queue<types.Message> _unReadMessages;

  List<types.Message> get messages => _messages;

  final int _chatRoomNumber;

  int get chatRoomNumber => _chatRoomNumber;
  final bool _isSingle;
  late List<User>? chatUsers;
  late User? chatUser;
  final String name;

  final types.User _user;

  ChatRoom(this._chatRoomNumber,this._messages, this._isSingle,this.name,this._user,{this.chatUsers,this.chatUser}):
        _unReadMessages = Queue<types.Message>();

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
    print("聊天框#${chatRoomNumber}添加消息:${message}");
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

  int _unReadMessageNumber = 0;

  int get unReadMessageNumber => _unReadMessageNumber;

  void loadUnreadMessages(){
    _unReadMessageNumber = 0;
    while(!_unReadMessages.isEmpty){
      types.Message m = _unReadMessages.first;
      _messages.insert(0,m);
      _unReadMessages.removeFirst();
    }
  }
  void addUnreadOuterMessage(User sender, String message){
    final textMessage = types.TextMessage(
      author: sender.toChatUser(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message,
    );
    _unReadMessages.add(textMessage);
    _unReadMessageNumber = _unReadMessages.length;
    print("聊天框#${chatRoomNumber}未读消息:${_unReadMessageNumber}");
  }

  String getRemark(){
    if(!this._isSingle)
      return "";
    else
      return chatUser!.reMark;
  }

  Color getRemarkColor(){

    if(!this._isSingle)
      return Colors.blue;
    if(chatUser!.reMark == "小恶魔" ||chatUser!.reMark == "间谍" ||chatUser!.reMark == "红唇女郎" ||chatUser!.reMark == "投毒者")
      return Colors.red;
    else return Colors.blue;
  }



}