import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:my_flutter_app/Widgets/UserCardWidget.dart';
import 'package:web_socket_channel/io.dart';
import '../common/Global.dart';
import '../Models/User.dart';
import 'dart:convert';
import '../common/Global.dart';

class WaitInRoomPageArgs {
  late String _name;
  late int _maxPeople;
  late int _roomNumber;
  late bool _isCreateRoom;

  WaitInRoomPageArgs.fromJoin(this._roomNumber) {
    _isCreateRoom = false;
  }

  WaitInRoomPageArgs.fromCreate(this._name, this._maxPeople) {
    _isCreateRoom = true;
  }

  bool get isCreateRoom => _isCreateRoom;

  int get maxPeople => _maxPeople;

  String get name => _name;

  int get roomNumber => _roomNumber;
}

class WaitInRoomPage extends StatefulWidget {
  final WaitInRoomPageArgs _args;

  WaitInRoomPageArgs get args => _args;

  WaitInRoomPage(this._args);

  @override
  State<StatefulWidget> createState() => WaitInRoomPageState();
}

class WaitInRoomPageState extends State<WaitInRoomPage> {
  late Room _room;
  late List<User> _users;

  @override
  void initState() {
    super.initState();
    _room = new Room.buildDefault();
    _users = <User>[];
    Global.channel.sink.add(jsonEncode({
      "verb": widget.args.isCreateRoom ? "create_room" : "join_room",
      "body": widget.args.isCreateRoom
          ? {
              "max_people": widget.args.maxPeople,
              "name": widget.args.name,
            }
          : {
              "room_number": widget.args.roomNumber,
            }
    }));
  }

  void addOneMemberList(dynamic member) {
    setState(() => {_users.add(User.buildFromJSON(member))});
  }

  void _exitRoom() {
    Global.channel.sink.close();
    Global.channel = null;
    Navigator.of(context).pop();
  }
  void _startGame(){
    Global.channel.sink.add(jsonEncode({
      "verb":"start_game"
    }));
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
          stream: Global.stream!,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            print(Global.channel.closeCode);
            print(Global.channel.closeReason);
            if (Global.channel.closeCode != null) {
              print("Server Close Code:" + Global.channel.closeCode.toString());
              if(Global.channel.closeReason != null)
                print("Close Reason:" + Global.channel.closeReason);
              Navigator.of(context).pop();
              return const Text("Connection Closed!");
            } else if (snapshot.hasData && snapshot.data == "connect success") {
              print("connect success");
            } else if (snapshot.hasData) {
              dynamic jsonData = jsonDecode(snapshot.data as String);
              if (jsonData["verb"] == "game_started"){
                Navigator.of(context).pushNamed(
                    "GamePage",
                    arguments:_room
                );
              }else if (jsonData["verb"] == "create_room_success") {
                _room = Room.buildFromJSON(jsonData["room"]);
                _users.add(_room!.homeOwner);
              } else if (jsonData["verb"] == "someone_join_room") {
                _users.add(User.buildFromJSON(jsonData["user"]));
              } else if (jsonData["verb"] == "someone_exit_room") {
                _users.removeWhere(
                    (u) => u.equals(User.buildFromJSON(jsonData["user"])));
              }
            }
            return Center(
              child: Column(children: <Widget>[
                Text("Room:${_room?.name}\tHomeOwner:${_room?.homeOwner.name}\tRoomNumber:${_room?.roomNumber}"),
                Row(
                  children: <Widget>[
                    const Image(
                      image: AssetImage("images/avatar.png"),
                      width: 50,
                      height: 50,
                    ),
                    Text(Global.userProfile.name)
                  ],
                ),
                SizedBox(
                    width: 300,
                    height: 200,
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        return UserCardWidget(_users[index]);
                      },
                    )),
                Row(
                  children: <Widget>[
                    _room.homeOwner.equals(Global.userProfile)?ElevatedButton(
                    onPressed: _startGame,
                    child: const Text("Start Game"),
                  ):SizedBox(),
                    ElevatedButton(
                      onPressed: _exitRoom,
                      child: const Text("Exit Room"),
                    ),
                    Text("Time to start: 05:00")
                  ],
                )
              ]),
            );
          },
        ));
  }
}
