import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/User.dart';
import 'package:auto_size_text/auto_size_text.dart';


class UserCardWidget extends StatefulWidget{
  
  final User _user;
  final int _seatNumber;

  const UserCardWidget(this._user, this._seatNumber, {super.key});
  UserCardWidget.buildDefault(this._seatNumber):
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
      width: 65,
      height: 65,
      child:Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child:Image(
                  image: !widget._user.isDefault()?AssetImage(widget._user.avatarUri):AssetImage("images/empty_seat.jpg"),
                ),
            ),

            AutoSizeText(
              (widget._seatNumber!=-1?widget._seatNumber.toString():"") + " " + ((widget._user!=null)?widget._user.name:""),
              style: TextStyle(fontSize: 2),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ) ,
    );

  }
  
}