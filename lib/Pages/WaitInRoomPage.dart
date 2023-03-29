import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/Room.dart';
import 'package:my_flutter_app/Widgets/UserCardWidget.dart';
import '../common/Global.dart';
import '../Models/User.dart';

class WaitInRoomPage extends StatefulWidget{
  final Room _room;

  WaitInRoomPage(this._room);

  @override
  State<StatefulWidget> createState() => WaitInRoomPageState();

}

class WaitInRoomPageState extends State<WaitInRoomPage>{

  void _exitRoom(){}
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body:Center(
          child: Column(
              children:<Widget>[
                Text("Home:" + widget._room.name + "HomeOwner:" + widget._room.homeOwner.name),
                Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage("images/avatar.png"),
                      width: 50,
                      height: 50,
                    ),
                    Text((Global.userProfile as User).name)
                  ],
                ),
                SizedBox(
                  width: 300,
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: Global.userLab.count(),
                    itemBuilder: (context,index){
                      return UserCardWidget(Global.userLab.getUser(index));
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text("Exit Room!"),
                      onPressed: _exitRoom,
                    ),
                    Text("Time to start: 05:00")
                  ],
                )

              ]

          ),
        )
    );
  }
}