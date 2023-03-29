import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/User.dart';

class UserCardWidget extends StatefulWidget{
  
  final User _user;

  const UserCardWidget(this._user, {super.key});

  @override
  State<StatefulWidget> createState() => UserCardWidgetState();
  
}
class UserCardWidgetState extends State<UserCardWidget>{

  void _addAsFriend(){}
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("images/avatar.png"),
            width: 30,
            height: 30,
          ),
          Text(widget._user.name),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child:Container(
            width: 20,
            height: 20,
              child:ElevatedButton(
                child:Icon(Icons.person_add,size: 20,color: Colors.white,),
                onPressed: (){},
              )
          )
    )
        ],
      ),
    );
  }
  
}