import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterRoomPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EnterRoomPageState();

  final bool isOnlineMode;

  EnterRoomPage({Key?key,required this.isOnlineMode }):super(key: key);
}

class EnterRoomPageState extends State<EnterRoomPage>{

  void createRoom(){
    var result = Navigator.of(context).pushNamed(
        "CreateRoomPage"
    );
  }
  void joinRoom(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(
              width: 120,
              height: 120,
              child: ElevatedButton(
                onPressed: createRoom,
                child: const Text("Create Room"),
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
              width: 120,
              height: 120,
              child: ElevatedButton(
                onPressed: joinRoom,
                child: const Text("Join Room"),
              ),
            )
          ],
        )
      ),
    );
  }

}