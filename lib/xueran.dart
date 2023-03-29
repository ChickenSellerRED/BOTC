import "dart:async";

import "package:flutter/material.dart";
import "package:my_flutter_app/Pages/CreateRoomPage.dart";
import "package:my_flutter_app/Pages/JoinRoomPage.dart";
import "package:my_flutter_app/Pages/WaitInRoomPage.dart";
import "Models/Room.dart";
import "Pages/EnterRoomPage.dart";
import "Pages/SwitchGameModePage.dart";
import "common/Global.dart";

void main(){
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
            // Cast the arguments to the correct
            // type: ScreenArguments.
            print(settings.arguments.toString());

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return WaitInRoomPage(settings.arguments as Room);
              },
            );
          }
        }

    );
  }
}
