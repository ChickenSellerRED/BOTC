import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:my_flutter_app/Pages/GamePage.dart';
import 'package:my_flutter_app/Widgets/UserCardWidget.dart';
import 'package:my_flutter_app/Widgets/UserLayoutWidget.dart';
import 'package:web_socket_channel/io.dart';
import '../common/Global.dart';
import '../Models/User.dart';
import 'dart:convert';
import '../common/Global.dart';
import '../common/Tools.dart';

class WaitInRoomPageArgs {
  late String _name;
  late int _maxPeople;
  late int _roomNumber;
  bool _isCreateRoom;

  WaitInRoomPageArgs.fromJoin(this._roomNumber):
    _isCreateRoom = false;

  WaitInRoomPageArgs.fromCreate(this._name, this._maxPeople):_isCreateRoom = true;


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
  late List<User> _seats;
  late List<int> _seatNumber;
  final subscription = Global.stream.listen(null);
  @override
  void initState() {
    super.initState();
    _initSubscription();
    print(widget._args.name);
    _room = Room.buildDefault();
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
  void _initSubscription(){
    subscription.onData((event){
      dynamic json = Tools.json2Map(event);
      print(event);
      // print(Global.channel.closeCode);
      // print(Global.channel.closeReason);
      if (Global.channel.closeCode != null) {
        print("Server Close Code:" + Global.channel.closeCode.toString());
        if(Global.channel.closeReason != null)
          print("Close Reason:" + Global.channel.closeReason);
        Navigator.of(context).pop();
        return const Text("Connection Closed!");
      } else if (event == "connect success") {
        print("connect success");
      } else {
        if (json["verb"] == "game_started"){
          Navigator.of(context).pushNamed(
              "GamePage",
              arguments:_room
          );
        }else if (json["verb"] == "create_room_success") {
          setState((){
            _room = Room.buildFromJSON(json["room"]);
            _testInitUsers();
            _initSeatNumber();
          });
        } else if (json["verb"] == "someone_join_room") {
          _users.add(User.buildFromJSON(json["user"]));
        } else if (json["verb"] == "someone_exit_room") {
          _users.removeWhere(
                  (u) => u.equals(User.buildFromJSON(json["user"])));
        }else if (json["verb"] == "room_close") {
          print("room closed, reason:"+json["reason"]);
          Navigator.of(context).pop();
        }
      }
    });
  }
  void _initSeatNumber(){
    print("_initSeatNumber");
    switch(this._room.maxpeople){
      case 5:
        _seatNumber = [0,4,7,8,11];
        break;
      case 6:
        _seatNumber = [1,4,7,8,11,14];
        break;
      case 7:
        _seatNumber = [0,1,4,7,8,11,14];
        break;
      case 8:
        _seatNumber = [0,1,3,4,7,8,11,14];
        break;
      case 9:
        _seatNumber =  [0,1,3,4,7,8,11,12,14];
        break;
      case 10:
        _seatNumber = [0,1,3,4,5,7,8,11,12,14];
        break;
      case 11:
        _seatNumber = [0,1,3,4,5,7,8,10,11,12,14];
        break;
      case 12:
        _seatNumber = [0,1,3,4,5,6,7,8,10,11,12,14];
        break;
      case 13:
        _seatNumber = [0,1,3,4,5,6,7,8,9,10,11,12,14];
        break;
      case 14:
        _seatNumber = [0,1,2,3,4,5,6,7,8,9,10,11,12,14];
        break;
      case 15:
        _seatNumber = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
        break;
      default:
        break;

    }

  }
  void _testInitUsers(){
    _seats = List<User>.filled(15, User.buildDefault());
    print("_testInitUsers");
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
    _addAMember(User('刘林虎',"images/avatar_1.png"));
    _addAMember(User('李家豪',"images/avatar_0.png"));
  }

  void _addAMember(User user){
    _users.add(user);
    for(int i=0;i<_seats.length;i++){
      if(_seats[i].isDefault()){
        _seats[i] = user;
        return;
      }
    }
  }

  void _exitRoom() {
    Global.channel.sink.close();
    Global.channel = null;
    Navigator.of(context).pop();
  }
  void _startGame(){
    Global.channel.sink.add(jsonEncode({
      "verb":"start_game",
      "body":{
          "townsfolk":["占卜师","僧侣","圣女","士兵","厨师","掘墓人"],
          "outsiders":["圣徒"],
          "minions":["投毒者"],
          "demons":["小恶魔"],
      }
    }));
    Navigator.of(context).pushNamed(
        "GamePage",
        arguments:GamePageArgument(_room, _seats)
    );
  }

  void _switchSeats(int target,int index){
    setState(() {
      User tem = _seats[target];
      _seats[target] = _seats[index];
      _seats[index] = tem;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,//解决弹出式键盘导致底部overflow的问题
        appBar: AppBar(),
        body: _room.roomNumber!=-1?Center(
              child: Column(children: <Widget>[
                Text("Room:${_room?.name}\tHomeOwner:${_room?.homeOwner.name}\tRoomNumber:${_room?.roomNumber}"),
                Row(
                  children: <Widget>[
                    const Image(
                      image: AssetImage("images/avatar.png"),
                      width: 50,
                      height: 50,
                    ),
                    Text(Global.userProfile.name),
                    // Text(_seats[0].name)
                  ],
                ),
                UserLayoutWidget(_seats, _seatNumber, _switchSeats),
                Container(child:Row(
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
                ))
              ]),
            ):Container(child: Text("void"),)
          ,

    );
  }
}