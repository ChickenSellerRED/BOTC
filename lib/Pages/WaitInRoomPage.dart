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

class WaitInRoomPage extends StatefulWidget{
  final Room _room;

  WaitInRoomPage(this._room);

  @override
  State<StatefulWidget> createState() => WaitInRoomPageState();

}

class WaitInRoomPageState extends State<WaitInRoomPage>{
   late final channel;
   late List<User> users;
  @override
  void initState() {
    channel = IOWebSocketChannel.connect('ws://10.0.2.2:3000',headers: Global.userProfile.toHeader());
    users = <User>[];
    channel.sink.add(jsonEncode({
      "verb":"create_room",
      "body":{
        "maxPeople":998,
        "name":"五影会谈",
      }
    }));
  }

  void addOneMemberList(dynamic member){
    setState(()=>{
        users.add(User.buildFromJSON(member))
    });
  }
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
                  child: StreamBuilder(
                    stream:channel.stream,
                    builder:(context, snapshot){
                      if(snapshot.hasData){
                        dynamic JSONData = jsonDecode(snapshot.data as String);
                        if(JSONData["verb"] == "create_room_success"){
                          // addOneMemberList(JSONData["memberList"][0]);
                          users.add(User.buildFromJSON(JSONData["memberList"][0]));
                        }else if(JSONData["verb"] == "someone_join_room"){
                          users.add(User.buildFromJSON(JSONData["user"]));
                        }
                      }
                      return GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: this.users.length,
                          itemBuilder: (context,index){
                          return UserCardWidget(this.users[index]);
                        },
                      );
                  }
                    ,
                  )

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