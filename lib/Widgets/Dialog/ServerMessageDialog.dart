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
  @override
  void initState() {
    super.initState();
    _sm = widget.sm;
    _game = widget.game;
    _choosingUsers = [];
    _maxUser = 0;
    _selectedUser = -1;
  }
  @override
  Widget build(BuildContext context) {
    _maxUser = 2;

    switch(_sm.verb){
      case "passive_information_need": //说书人提供被动信息
        if(_sm.body["character"] == "占卜师")
          _maxUser = 2;
        break;

    }
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
                    if(_choosingUsers.contains(userNumber))
                      _choosingUsers.remove(userNumber);
                    else{
                      if(_choosingUsers.length != _maxUser)
                        _choosingUsers.add(userNumber);
                    };
                  });

              },)
            ),
            Row(
              children: List<ChoiceChip>.generate(3, (index){
                return ChoiceChip(
                  label: Text("选项 "+index.toString()),
                  selected: _selectedUser==index,
                  onSelected: (isSelected) {
                    if(isSelected)
                      setState(() {
                        _selectedUser = index;
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