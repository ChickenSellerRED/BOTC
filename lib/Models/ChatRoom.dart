import 'dart:ui';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'User.dart';

class ChatRoom{
  final List<types.Message> _messages;
  final bool _isSingle;
  late List<User>? chatUsers;
  late User? chatUser;
  final String name;

  ChatRoom(this._messages, this._isSingle,this.name,{this.chatUsers,this.chatUser});

  String generateChatAvatarUri(){
    if(!_isSingle)
      return "images/evil_chat_avatar.png";
    else return chatUser!.chatAvatarUri;
  }
}