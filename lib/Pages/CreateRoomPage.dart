import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:my_flutter_app/Models/Room.dart";
import "package:web_socket_channel/io.dart";
import "../common/Global.dart";
import "../Models/User.dart";
import "WaitInRoomPage.dart";


class CreateRoomPage extends StatefulWidget{

  CreateRoomPage();

  @override
  State<StatefulWidget> createState() => CreateRoomPageState();

}

class CreateRoomPageState extends State<CreateRoomPage>{

  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _maxPeopleController = TextEditingController();
  void _creatRoom(){
    if(!Global.isOnline){
      Global.channel = IOWebSocketChannel.connect('ws://10.0.2.2:3000',
          headers: Global.userProfile.toHeader());
      Global.stream = Global.channel.stream.asBroadcastStream();
      Global.stream.listen(
        (event){
        }
      );
      var result = Navigator.of(context).pushNamed(
          "WaitInRoomPage",
          arguments: WaitInRoomPageArgs.fromCreate(_nameController.text, int.parse(_maxPeopleController.text))
      );
      print("路由返回值：$result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      controller:_nameController,
                      decoration: InputDecoration(
                          labelText: "Input Room Name"
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _maxPeopleController,
                      decoration: InputDecoration(
                        labelText: "Max people limit",
                      ),
                    )
                  ],
                )
            ),
            ElevatedButton(
              child: Text("Create Room!"),
              onPressed: _creatRoom,
            )
          ]

      ),
    )
    );
  }
}