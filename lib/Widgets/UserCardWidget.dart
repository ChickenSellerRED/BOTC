import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/User.dart';

class UserCardWidget extends StatefulWidget{
  
  final User _user;

  const UserCardWidget(this._user, {super.key});
  UserCardWidget.buildDefault():
      _user = User.buildDefault();

  @override
  State<StatefulWidget> createState() => UserCardWidgetState();
  
}
class UserCardWidgetState extends State<UserCardWidget>{

  void _addAsFriend(){}
  @override
  Widget build(BuildContext context) {
    return
    SizedBox(
      width: 80,
      height: 80,
      child:Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child:Image(
                  image: !widget._user.isDefault()?AssetImage(widget._user.avatarUri):AssetImage("images/empty_seat.jpg"),
                ),
            ),

            Text(widget._user!=null?widget._user.name:"",
            ),
          ],
        ),
      ) ,
    );

  }
  
}