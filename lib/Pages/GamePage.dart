import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:my_flutter_app/Widgets/Dialog/ServerMessageDialog.dart';
import 'dart:convert';
import 'dart:math';

import '../Models/Game.dart';
import '../Models/GameSetting.dart';
import '../Models/User.dart';
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
  nominating,
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





  final List<types.Message> _messages = [];
  final _user = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
      firstName: "Jize",
      lastName: "Bi");


  void _send(dynamic data){
    Global.channel.sink.add(jsonEncode(data));
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
                    _game.sMessages.add(new ServerMessage(jsonVerb,jsonBody));
                  });
                }
                else {
                  switch(json["verb"]){
                    case "character_assign_result":
                      _game.characters = List<String>.from(jsonBody["characterList"]);
                      _game.assignCharacters();
                      break;
                  }
                }
          }
      );
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

    _addMessage(textMessage);

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
          Center(
            child: ElevatedButton(
          onPressed: (){
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
            }, child: Text(!_game.sMessages.isEmpty?"new message!":"null"),
      )
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
                          constraints: BoxConstraints(minHeight: 657),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                                selectedIndex: _selectedChatIndex,
                                onDestinationSelected: (int index) {
                                  setState(() {
                                    _selectedChatIndex = index;
                                  });
                                },
                                labelType: NavigationRailLabelType.selected,
                                destinations:
                                    List<NavigationRailDestination>.generate(
                                        9,
                                        (index) => NavigationRailDestination(
                                              icon: Icon(Icons.favorite_border),
                                              selectedIcon:
                                                  Icon(Icons.favorite),
                                              label: Text('First'),
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
