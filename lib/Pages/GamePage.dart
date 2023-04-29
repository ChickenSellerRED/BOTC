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

  late List<ChatRoom> _chatRooms = [];
  late List<types.Message> _messages = [];
  late int _chatWindowNumber;

  final _user = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
      firstName: "Jize",
      lastName: "Bi");


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
                  switch(json["verb"]){
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
                  }
                }
          }
      );
    }
  }
  void _initChatRoom(){
    if(_game.ishomeOwner)
      _chatWindowNumber = _room.maxpeople+1;//如果是房主就和每个人都有聊天框+邪恶群聊
    else{
      _chatWindowNumber = 0;
    }
    if(_game.ishomeOwner){
      List<User> evils = _game.getEvils();
      _chatRooms.add(ChatRoom([], false,"邪恶阵营",chatUsers:evils));
      _game.seats.forEach((u) {_chatRooms.add(ChatRoom([], true,u.name,chatUser:u));});
    }else{
      if(Global.userProfile.isEvil()){
        _chatRooms.add(ChatRoom([], true,"说书人",chatUser:_room.homeOwner));
        List<User> evils = _game.getEvils();
        evils = evils.where((u) => u.equals(Global.userProfile)).toList();
        evils.add(_room.homeOwner);
        _chatRooms.add(ChatRoom([], false,"邪恶阵营",chatUsers:evils));
        _game.seats.forEach((u) {
          if(!u.equals(Global.userProfile))
            _chatRooms.add(ChatRoom([], true,u.name,chatUser:u));
        });
      }
    }
  }


  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Seat"),
      BottomNavigationBarItem(icon: new Icon(Icons.search), label: "Chat"),
    ];
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    final otherMessage = types.TextMessage(
      author: types.User(
          id: '82091001-a484-4a89-ae75-a22bf8d6f3ac',
          firstName: "Jize",
          lastName: "Bi"),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "朕知道了",
    );
    var timer = Timer(Duration(seconds: 1), () => _addMessage(otherMessage));
    // timer.cancel();
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
                    Text("${_game.sMessages.length}"),
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
                    IconButton(icon: Icon(Icons.chat_outlined),onPressed: (){},),
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
                print(constraint.maxHeight);
                //todo:解决项比较少时，滚动不固定的问题
                return Padding(
                    padding: EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 0),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                                selectedIndex: _selectedChatIndex,
                                // backgroundColor: Colors.green,
                                selectedIconTheme: IconThemeData(
                                  color: Colors.red
                                ),
                                onDestinationSelected: (int index) {
                                  setState(() {
                                    _selectedChatIndex = index;
                                  });
                                },
                                labelType: NavigationRailLabelType.selected,
                                destinations:
                                    List<NavigationRailDestination>.generate(
                                        _chatRooms.length,
                                          (index) => NavigationRailDestination(
                                              padding: EdgeInsets.all(0),
                                              icon: ChatAvatar(_chatRooms[index].generateChatAvatarUri(),false),
                                              selectedIcon:ChatAvatar(_chatRooms[index].generateChatAvatarUri(),true),
                                              label: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  _chatRooms[index].name
                                              ),

                                            ))),
                          )),
                    ));
              }),
              VerticalDivider(thickness: 1, width: 1),
              // This is the main content.
              Expanded(
                child: Center(
                  child: Chat(
                    messages: _messages,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                    showUserAvatars: true,
                    showUserNames: true,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
