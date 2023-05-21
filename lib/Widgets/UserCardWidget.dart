import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/User.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserCardWidget extends StatefulWidget {
  final User _user;
  final int _seatNumber;

  const UserCardWidget(this._user, this._seatNumber, {super.key});

  UserCardWidget.buildDefault(this._seatNumber) : _user = User.buildDefault();

  @override
  State<StatefulWidget> createState() => UserCardWidgetState();
}

class UserCardWidgetState extends State<UserCardWidget> {
  void _addAsFriend() {}

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image(
                image: !widget._user.isDefault()
                    ? AssetImage(widget._user.avatarUri)
                    : AssetImage("images/empty_seat.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            AutoSizeText(
              (widget._seatNumber != -1 ? widget._seatNumber.toString() : "") +
                  " " +
                  ((widget._user != null) ? widget._user.name : ""),
              style: TextStyle(fontSize: 2),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      !widget._user.isPoison?const Positioned(
          top: 5,
          left: -1.5,
          child: Image(
            image: AssetImage("images/poison.png"),
            width: 15,
            height: 12,
          )):Container(),
      widget._user.isProtected?const Positioned(
          top: 20,
          left: 51,
          child: Image(
            image: AssetImage("images/cross.png"),
            width: 15,
            height: 12,
          )):Container(),
      widget._user.character=="酒鬼"?const Positioned(
          top: 20,
          left: -1.5,
          child: Image(
            image: AssetImage("images/beer.png"),
            width: 15,
            height: 12,
          )):Container(),
      Container(
        width: 65,
        height: 65,
        color: Colors.grey.withOpacity(widget._user.isAlive ? 0 : .75),
      ),
      widget._user.canVote?const Positioned(
          top: 5,
          left: 51,
          child: Image(
            image: AssetImage("images/ticket.png"),
            width: 15,
            height: 12,
          )):Container(),
    ]);
  }
}
