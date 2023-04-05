import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../Models/Room.dart';
import '../common/Global.dart';

class SwitchGameModePage extends StatefulWidget{

  final String title;

  @override
  State<StatefulWidget> createState()=>SwitchGameModePageState();

  const SwitchGameModePage({super.key, required this.title});


}

class SwitchGameModePageState extends State<SwitchGameModePage>{


  void startOfflineMode(){
    Navigator.of(context).pushNamed(
      "EnterRoomPage_Offline"
    );
    Global.isOnline = false;
  }
  void startOnlineMode(){
    Navigator.of(context).pushNamed(
        "GamePage",
        arguments:Room.buildDefault()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize:20)),
              child:const Text("Offline Mode"),
              onPressed: startOfflineMode,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize:20)),
                onPressed: startOnlineMode,
                child: const Text("Online Mode"),)
          ],
        ),
      ),
    );
  }

}

