import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Widgets/UserLayoutWidget.dart';

import '../../Models/Game.dart';
import '../../Models/User.dart';
import '../../common/ServerMessage.dart';

class ServerMessageDialog extends StatefulWidget{

  final ServerMessage sm;
  final Game game;


  ServerMessageDialog(this.sm,this.game, {super.key});

  @override
  State createState() => ServerMessageDialogState();
}
class ServerMessageDialogState extends State<ServerMessageDialog>{

  late ServerMessage _sm;
  late Game _game;
  late List<int> _choosingUsers;
  late int _maxUser;
  late int _selectedUser;
  late String _hint;
  @override
  void initState() {
    super.initState();
    _sm = widget.sm;
    _game = widget.game;
    _choosingUsers = [];
    _maxUser = 0;
    _selectedUser = -1;
    _initHint();
  }
  void _initHint(){
    if(_game.ishomeOwner){//是房主
      switch(_sm.verb){
        case "passive_information_need": //说书人提供被动信息
          if(_sm.body["character"] == "洗衣妇"){
            _maxUser = 2;
            _hint = "选择两位玩家，并指明其中一位的村民身份";
          }
          else if(_sm.body["character"] == "图书管理员"){
            _maxUser = 2;
            _hint = "选择两位玩家，并指明其中一位的外来者身份";
          }
          else if(_sm.body["character"] == "调查员"){
            _maxUser = 2;
            _hint = "选择两位玩家，并指明其中一位的爪牙身份";
          }
          else if(_sm.body["character"] == "厨师"){
            _maxUser = 0;
            _hint = "指明有多少对邪恶玩家为邻座";
          }
          else if(_sm.body["character"] == "共情者"){
            _maxUser = 0;
            _hint = "指明在共情者两侧最靠近他的有多少玩家是邪恶的";
          }
          else if(_sm.body["character"] == "送葬者"){
            _maxUser = 0;
            _hint = "指明今天被处决的玩家的角色";
          }
          break;
      }
    }else{//不是房主

    }

  }
  @override
  Widget build(BuildContext context) {
    _maxUser = 2;


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child:UserLayoutWidget(_game,choosingUsers: _choosingUsers, isChoosing: true, onClickCard: (int userNumber){
                  setState(() {
                    if(_choosingUsers.contains(userNumber)){
                      _choosingUsers.remove(userNumber);
                      if(_selectedUser == userNumber)
                        _selectedUser = -1;
                    }
                    else{
                      if(_choosingUsers.length != _maxUser)
                        _choosingUsers.add(userNumber);
                    };
                  });

              },)
            ),
            Column(
              children: List<ChoiceChip>.generate(_choosingUsers.length, (index){
                int userNumber = _choosingUsers[index];
                return ChoiceChip(
                  label: Text("玩家 " + userNumber.toString() + " " + (_game.ishomeOwner?("("+this._game.seats[userNumber].character+")"):"") + _game.seats[userNumber].name),
                  selected: _selectedUser==userNumber,
                  onSelected: (isSelected) {
                    if(isSelected)
                      setState(() {
                        _selectedUser = userNumber;
                      });
                  },
                );
              })
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlatButton {
}