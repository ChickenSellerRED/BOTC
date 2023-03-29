import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/Global.dart';
import '../Models/User.dart';

class JoinRoomPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => JoinRoomPageState();

}

class JoinRoomPageState extends State<JoinRoomPage>{
  GlobalKey _formKey = GlobalKey<FormState>();
  void _joinRoom(){}
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
              children:<Widget>[
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
                Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child:Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Room Number"
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Name will be used when entering"
                          ),
                        )
                      ],
                    )
                ),
                ElevatedButton(
                  child: Text("Join Room!"),
                  onPressed: _joinRoom,
                )
              ]

          ),
        ),
      );
  }

}