import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:my_flutter_app/Models/Room.dart";
import "package:web_socket_channel/io.dart";
import "../Widgets/SelectCharacterItem.dart";
import "../Widgets/SelectCharacterSection.dart";
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

  List<bool> folkSelected = List<bool>.generate(1, (index) => false);
  void _creatRoom(){
    if(!Global.isOnline){
      Global.channel = IOWebSocketChannel.connect('ws://10.0.2.2:3000',
          headers: Global.userProfile.toHeader());
      Global.stream = Global.channel.stream.asBroadcastStream();
      final subscription = Global.stream.listen(null);
      subscription.onData((event){
        subscription.cancel();
        var result = Navigator.of(context).pushNamed(
            "WaitInRoomPage",
            arguments: WaitInRoomPageArgs.fromCreate(_nameController.text, int.parse(_maxPeopleController.text))
        );
        print("路由返回值：$result");
      });
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
                    ),
                    Divider(),
                    SelectCharacterSection("村民",List<SelectCharacterItem>.generate(1,(index){return SelectCharacterItem(Icon(Icons.add));}),folkSelected),
                    Text("${folkSelected[0]}")
                    // Divider(),
                    // SelectCharacterSection("外来者",1),
                    // Divider(),
                    // SelectCharacterSection("爪牙",1),
                    // Divider(),
                    // SelectCharacterSection("恶魔",1),

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