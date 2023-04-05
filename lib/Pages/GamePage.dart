import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:convert';
import 'dart:math';

class GamePage extends StatefulWidget{
  Room _room;

  GamePage(this._room);

  @override
  State createState()=>GamePageState();
}

class GamePageState extends State<GamePage>{
//todo:禁用系统返回
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedChatIndex = 0;
  int bottomSelectedIndex = 0;

  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: "Jize",
    lastName: "Bi");

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          label: "Seat"
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.search),
        label: "Chat"
      ),
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
      author: types.User(id: '82091001-a484-4a89-ae75-a22bf8d6f3ac',
          firstName: "Jize",
          lastName: "Bi"),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "朕知道了",
    );
    var timer = Timer(Duration(seconds: 1),()=>_addMessage(otherMessage));
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child:AppBar()
      ),
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
              NavigationRail(
                selectedIndex: _selectedChatIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedChatIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.selected,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('First'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bookmark_border),
                    selectedIcon: Icon(Icons.book),
                    label: Text('Second'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.star_border),
                    selectedIcon: Icon(Icons.star),
                    label: Text('Third'),
                  ),
                ],
              ),
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
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}