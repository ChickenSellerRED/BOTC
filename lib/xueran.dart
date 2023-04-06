import "dart:async";

import "package:flutter/material.dart";
import "package:my_flutter_app/Pages/CreateRoomPage.dart";
import "package:my_flutter_app/Pages/JoinRoomPage.dart";
import "package:my_flutter_app/Pages/WaitInRoomPage.dart";
import "Models/Room.dart";
import "Pages/EnterRoomPage.dart";
import "Pages/GamePage.dart";
import "Pages/SwitchGameModePage.dart";
import "common/Global.dart";
import 'Pages/WaitInRoomPage.dart';
import 'package:flutter/rendering.dart';

void main(){
  // debugPaintSizeEnabled = true;
  Global.init();
  runApp(const BOTC());
}

class BOTC extends StatelessWidget{
  const BOTC ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blood Of The Clocktower",
      theme: ThemeData(
        primarySwatch:Colors.green
      ),
      routes: {
        "/":(context)=>const SwitchGameModePage(title:"Choose your game mode"),
        "EnterRoomPage_Offline":(context)=>EnterRoomPage(isOnlineMode: false),
        "EnterRoomPage_Online":(context)=>EnterRoomPage(isOnlineMode: true),
        "CreateRoomPage":(context)=>CreateRoomPage(),
        "JoinRoomPage":(context)=>JoinRoomPage(),

      },
        onGenerateRoute:(RouteSettings settings){
          print(settings.toString());
          if (settings.name == "WaitInRoomPage") {
            return MaterialPageRoute(
              builder: (context) {
                return WaitInRoomPage(settings.arguments as WaitInRoomPageArgs);
              },
            );
          }else if(settings.name == "GamePage"){
            return MaterialPageRoute(
              builder: (context) {
                return GamePage(settings.arguments as Room);
              },
            );
          }
        }

    );
  }
}
