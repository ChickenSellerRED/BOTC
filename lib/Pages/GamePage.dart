import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:convert';
import 'dart:math';

import '../Models/User.dart';
import '../common/Global.dart';
import '../common/Tools.dart';
import 'GamePage.dart';

class GamePageArgument {
  Room _room;
  List<User> _seats;

  Room get room => _room;

  GamePageArgument(this._room, this._seats);

  List<User> get seats => _seats;
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

  int _days = 0;//游戏天数
  Stage _state = Stage.night;//当前游戏的阶段
  bool _isNightNow() => _state==Stage.night;//现在是否是晚上
  User nominatingUser = User.buildDefault();//正在被提名的玩家
  Map<User,int> _nominees = Map();//在处刑台上的所有玩家以及票数
  User _executingUser = User.buildDefault();//将被处刑的玩家
  List<String> _gameLog = List<String>.empty();//游戏日志

  //说书人专用
  late List<String> _characters; //根据座位排序的角色信息

  final List<types.Message> _messages = [];
  final _user = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
      firstName: "Jize",
      lastName: "Bi");


  @override
  void initState() {
    if(Global.channel != null){
      Global.stream.listen(
              (event){
                dynamic json = Tools.json2Map(event);
            _characters = json["characterList"];
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
            child: Text("Seat"),
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
