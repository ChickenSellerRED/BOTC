import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/ChatRoom.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:my_flutter_app/Widgets/ChatAvatar.dart';
import 'package:my_flutter_app/Widgets/Dialog/ServerMessageDialog.dart';
import 'package:my_flutter_app/Widgets/UserLayoutWidget.dart';
import 'dart:convert';
import 'dart:math';

import '../Models/Game.dart';
import '../Models/GameSetting.dart';
import '../Models/User.dart';
import '../Widgets/BlockImgButton.dart';
import '../Widgets/MessageList.dart';
import '../common/Global.dart';
import '../common/ServerMessage.dart';
import '../common/Tools.dart';
import 'GamePage.dart';

class GamePageArgument {
  Room _room;
  Game _game;
  GameSetting _gameSetting;

  Room get room => _room;

  GamePageArgument(this._room, this._game):
    this._gameSetting = GameSetting.buildDefault();

}

class GamePage extends StatefulWidget {
  GamePageArgument _args;

  GamePage(this._args);

  @override
  State createState() => GamePageState();
}
enum Stage<String> {
  freeTalking,
  voting,
  night
}

class GamePageState extends State<GamePage> {
//todo:禁用系统返回
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedChatIndex = 0;
  int _bottomSelectedIndex = 0;


  late Room _room;
  late Game _game;

  late List<ChatRoom> _chatRooms = [ChatRoom(1, [], true, "自己", types.User(id:"123"))];
  late List<types.Message> _messages = [];
  late int _chatWindowNumber;

  late types.User _user;

  GlobalKey _bottomNavigationKey = GlobalKey<State<BottomNavigationBar>>();
  GlobalKey _chatNavigationKey = GlobalKey<State<NavigationRail>>();
  final ScrollController _scrollController = ScrollController();


  int _unReadMessageNumber = 0;

  void _send(dynamic data){
    Global.channel.sink.add(jsonEncode(data));
  }

  void _addServerMessage(ServerMessage sm){
    setState(() {
      _game.sMessages.addFirst(sm);
    });
  }

  @override
  void initState() {
    _room = widget._args._room;
    _game = widget._args._game;
    _game.config(widget._args._gameSetting);

    if(Global.userProfile.equals(_room.homeOwner)){
      _game.ishomeOwner = true;
      _send({
        "verb":"start_game",
        "body":_game.gameSetting.toJSON()
      });
    }else{
      print("你不是房主");
      _game.ishomeOwner = false;
    }

    _user = types.User(
      id: Global.userProfile.uuid,
      firstName: Global.userProfile.name,
      lastName: _game.ishomeOwner?"说书人":"(玩家 #${Global.userProfile.seatNumber.toString()}");

    if(Global.channel != null){
      Global.stream.listen(
              (event){
                dynamic json = Tools.json2Map(event);
                dynamic jsonVerb = json["verb"];
                dynamic jsonBody = json["body"];
                print("new message:"+json.toString());
                print("Verb:"+jsonVerb.toString());
                print(jsonBody);
                if(jsonVerb.endsWith("_need") || jsonVerb.endsWith("_give")){
                  setState(() {
                    _addServerMessage(ServerMessage(jsonVerb,jsonBody));
                  });
                  return;
                }
                else {
                  switch(jsonVerb){
                    case "character_assign_result":
                      setState(() {
                        _game.characters = List<String>.from(jsonBody["characterList"]);
                        _game.assignCharacters();
                        _initChatRoom();
                      });
                      break;
                    case "your_character":
                      setState((){
                        Global.userProfile.character = jsonBody["character"];
                        Global.userProfile.fakeCharacter = jsonBody["fake_character"];
                      });
                      break;
                    case "new_chat_message":
                      int chatRoomNumber = jsonBody["chat_room_number"];
                      int fromSeatNumber = jsonBody["from_seat_number"];
                      _chatRooms.asMap().forEach((index,room) {
                        // print("chatRoomNumber:${room.chatRoomNumber} chatRoomNumber:${chatRoomNumber}");
                        if(room.chatRoomNumber == chatRoomNumber){
                          User sender = jsonBody["from_seat_number"]==-1?_room.homeOwner:_game.seats[fromSeatNumber];
                          if(_bottomSelectedIndex == 1  && _selectedChatIndex == index){//在当前屏幕 直接加载
                            setState(() {
                              room.addOuterMessage(sender, jsonBody["message"]);
                            });
                          }else{//没在当前屏幕 加到未读列表
                              room.addUnreadOuterMessage(sender,jsonBody["message"]);
                              setState(() {
                              _unReadMessageNumber ++;
                            });
                          }
                        }
                      });
                      break;
                  }
                }
          }
      );
    }
  }
  void _initChatRoom(){
    _chatRooms = [];
    if(_game.ishomeOwner)
      _chatWindowNumber = _room.maxpeople+1;//如果是房主就和每个人都有聊天框+邪恶群聊
    else{
      _chatWindowNumber = 0;
    }
    if(_game.ishomeOwner){
      List<User> evils = _game.getEvils();
      _chatRooms.add(ChatRoom(-2,[], false,"邪恶阵营",_user,chatUsers:evils));
      _game.seats.forEach((u) {_chatRooms.add(ChatRoom(u.seatNumber,[], true,u.name,_user,chatUser:u));});
    }else{
      _chatRooms.add(ChatRoom(-1,[], true,"说书人",_user,chatUser:_room.homeOwner));
      if(Global.userProfile.isEvil()){
        List<User> evils = _game.getEvils();
        evils = evils.where((u) => u.equals(Global.userProfile)).toList();
        evils.add(_room.homeOwner);
        _chatRooms.add(ChatRoom(-2,[], false,"邪恶阵营",_user,chatUsers:evils));

      }
      _game.seats.forEach((u) {
        if(!u.equals(Global.userProfile))
          _chatRooms.add(ChatRoom(u.seatNumber,[], true,u.name,_user,chatUser:u));
      });
    }
  }


  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Seat"),
      BottomNavigationBarItem(icon: new Icon(Icons.search), label: "Chat"),
    ];
  }



  void _handleSendPressed(types.PartialText message) {
    setState(() {
      _chatRooms[_selectedChatIndex].addMessage(message);
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  ServerMessage _checkServerMessage(){
    ServerMessage sm = _game.sMessages.first;
    return sm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(0.0), child: AppBar()),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: [
          Column(
            children: <Widget>[
              Text("房间:${_room.name}(${_room.roomNumber})"),
              Row(
                children:<Widget>[
                  Text("说书人:"),
                SizedBox(
                    width: 40,
                    height: 40,
                    child:Image(image: AssetImage(_room.homeOwner.avatarUri))),
                Text(_room.homeOwner.name)
                ]
              ),
              Row(
                children: <Widget>[
                  Text("第${_game.days}天"),
                  SizedBox(width: 50),
                  Text(_game.state==Stage.night?"夜晚":_game.state==Stage.freeTalking?"白天，自由讨论":"投票中${_game.voteFrom+1}号玩家 ==> ${_game.voteTo+1}号玩家")
                ],
              ),
              UserLayoutWidget(_game,isGaming:true),
              Row(
                children:<Widget>[
                  SizedBox(width: 20),
                  Column(
                  children: <Widget>[
                    BlockImgButton(key:UniqueKey(),Icons.notifications_none_outlined,_game.sMessages.length,
                        onPress: (){
                      if(_game.sMessages.isEmpty)
                        return;
                      showDialog(context: context,builder: (BuildContext context){
                        return ServerMessageDialog(_checkServerMessage(),_game);
                      }).then((value){
                        if(value == "yes") {
                          print("yes!");
                          setState(() {
                            _game.sMessages.removeFirst();
                          });
                        }
                      });
                    }
                    ),
                    BlockImgButton(key:UniqueKey(),Icons.chat_outlined, _unReadMessageNumber,
                        onPress: (){
                          print("chat_outlined clicked!");
                          setState(() {
                            //切换到聊天页
                            (_bottomNavigationKey.currentWidget as BottomNavigationBar).onTap!(1);
                            //切换到未读聊天页面
                            if(_unReadMessageNumber == 0)
                              return;
                            int unReadIndex = 0;
                            for(;unReadIndex<_chatRooms.length;unReadIndex++){
                              if(_chatRooms[unReadIndex].unReadMessageNumber > 0)
                                break;
                            }
                            _selectedChatIndex = unReadIndex;
                            _unReadMessageNumber -= _chatRooms[unReadIndex].unReadMessageNumber;
                            _chatRooms[unReadIndex].loadUnreadMessages();
                          });

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // while(!_scrollController.hasClients){
                            //   print("dont have clients!");
                            // }
                            print(_scrollController);
                            print("slide!");
                            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);

                          });
                          //控制滑动

                    }
                    ),
                    IconButton(icon: Icon(Icons.campaign_outlined),onPressed: (){},),

                  ],
                ),
                MessageList(290,250)]
              )

            ]
          ),
          Row(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraint) {
                // print(constraint.maxHeight);
                //todo:解决项比较少时，滚动不固定的问题
                return Padding(
                    padding: const EdgeInsets.all(0),
                    child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child:SingleChildScrollView(
                          controller: _scrollController,
                          child:
                          // SizedBox(height: 1000,width: 40,),
                          ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 0),
                              child: IntrinsicHeight(
                                child: NavigationRail(
                                    key: _chatNavigationKey,
                                    selectedIndex: _selectedChatIndex,
                                    // backgroundColor: Colors.green,
                                    selectedIconTheme: const IconThemeData(
                                        color: Colors.red
                                    ),
                                    onDestinationSelected: (int index) {
                                      setState(() {
                                        _selectedChatIndex = index;
                                        _unReadMessageNumber -= _chatRooms[_selectedChatIndex].unReadMessageNumber;
                                        _chatRooms[_selectedChatIndex].loadUnreadMessages();
                                      });

                                    },
                                    labelType: NavigationRailLabelType.selected,
                                    destinations:
                                    List<NavigationRailDestination>.generate(
                                        _chatRooms.length,
                                            (index) => NavigationRailDestination(
                                          padding: EdgeInsets.all(0),
                                          icon: ChatAvatar(_chatRooms[index].generateChatAvatarUri(),false,_chatRooms[index].unReadMessageNumber),
                                          selectedIcon:ChatAvatar(_chatRooms[index].generateChatAvatarUri(),true,_chatRooms[index].unReadMessageNumber),
                                          label: Text(
                                              overflow: TextOverflow.ellipsis,
                                              _chatRooms[index].name
                                          ),

                                        ))),
                              )),
                        )
                    )
                  );
              }),
              VerticalDivider(thickness: 1, width: 1),
              // This is the main content.
              Expanded(
                child: Center(
                  child: Chat(
                    messages: _chatRooms[_selectedChatIndex].messages,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                    showUserAvatars: false,
                    showUserNames: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: _bottomNavigationKey,
        currentIndex: _bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
