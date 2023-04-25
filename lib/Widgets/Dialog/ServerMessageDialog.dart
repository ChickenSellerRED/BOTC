import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/Widgets/UserLayoutWidget.dart';

import '../../Models/Game.dart';
import '../../Models/User.dart';
import '../../common/Global.dart';
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
  late bool _selectedBool;
  late String _selectCharacter;
  set selectedUser(int value) {
    _selectedUser = value;
    if(_selectedUser == -1)
      _selectCharacter = "无";
    else
      _selectCharacter = _game.seats[_selectedUser].character;
  }

  late String _hint;
  late int _inputNumber;
  @override
  void initState() {
    super.initState();
    _sm = widget.sm;
    _game = widget.game;
    _choosingUsers = [];
    _maxUser = 0;
    _selectedUser = -1;
    _selectCharacter = "无";
    _inputNumber = 0;
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
        case "proactive_information_need":
          if(_sm.body["character"] == "占卜师"){
            _maxUser = 0;
            _hint = "指明占卜师选中的玩家中是否有恶魔";
          }
          else if(_sm.body["character"] == "僧侣"){
            _maxUser = 0;
            _hint = "僧侣将保护${_sm.body["argument"]["user"]+1}号玩家";
          }
          else if(_sm.body["character"] == "管家"){
            _maxUser = 0;
            _hint = "管家选择了${_sm.body["argument"]["user"]+1}号玩家作为主人";
          }
          else if(_sm.body["character"] == "投毒者"){
            _maxUser = 0;
            _hint = "投毒者对${_sm.body["argument"]["user"]+1}号玩家下毒";
          }
          else if(_sm.body["character"] == "渡鸦守护者"){
            _maxUser = 0;
            _hint = "请为渡鸦守护者指明${_sm.body["argument"]["user"]+1}号玩家的角色";
          }
          else if(_sm.body["character"] == "小恶魔"){
            _dealImpKill();
          }
          break;
      }
    }else{//不是房主
      switch(_sm.verb){
        case "passive_information_give":
          dynamic information = _sm.body["information"];
          _maxUser = 0;
          if(_sm.body["character"] == "洗衣妇"){
            if(information["users"].length == 0)
              _hint = "没有村民";
            else{
              _hint = "${information["users"][0]+1}号玩家和${information["users"][0]+1}号玩家有一人是${information["character"]}";
            }
          }else if(_sm.body["character"] == "图书管理员"){
            if(information["users"].length == 0)
              _hint = "没有外来者";
            else{
              _hint = "${information["users"][0]+1}号玩家和${information["users"][0]+1}号玩家有一人是${information["character"]}";
            }
          }else if(_sm.body["character"] == "洗衣妇"){
            if(information["users"].length == 0)
              _hint = "没有爪牙";
            else{
              _hint = "${information["users"][0]+1}号玩家和${information["users"][0]+1}号玩家有一人是${information["character"]}";
            }
          }
          break;
        case "proactive_argument_need":
          if(_sm.body["character"] == "占卜师"){
            _maxUser = 2;
            _hint = "选择两名玩家，你会知道他们中是否有恶魔";
          }else if(_sm.body["character"] == "渡鸦守护者"){
            _maxUser = 1;
            _hint = "选择一名玩家，你会知道他的角色";
          }else if(_sm.body["character"] == "管家"){
            _maxUser = 1;
            _hint = "选择你的主人，明天投票时你只能跟着他投票";
          }else if(_sm.body["character"] == "投毒者"){
            _maxUser = 1;
            _hint = "选择一名玩家下毒，明天投票时你只能跟着他投票";
          }else if(_sm.body["character"] == "僧侣"){
            _maxUser = 1;
            _hint = "选择一名玩家保护";
          }else if(_sm.body["character"] == "小恶魔"){
            _maxUser = 1;
            _hint = "选择一名玩家鲨了";
          }
          break;
        case "proactive_information_give":
          dynamic information = _sm.body["information"];
          _maxUser = 0;
          if(_sm.body["character"] == "占卜师"){
            _hint = "${information["users"][0]+1}号玩家和${information["users"][1]+1}号玩家内${information["isThereADevil"]?"有":"没有"}恶魔";
          }else if(_sm.body["character"] == "渡鸦守护者"){
            _hint = "${information["user"]+1}号玩家的角色为${information["character"]}";
          }
      }
    }
  }
  void _send(dynamic data){
    Global.channel.sink.add(jsonEncode(data));
  }
  void _closeDialog(){
    if(_game.ishomeOwner){//是房主
      switch(_sm.verb){
        case "passive_information_need": //说书人提供被动信息
          if(_sm.body["character"] == "洗衣妇" || _sm.body["character"] == "图书管理员" || _sm.body["character"] == "调查员"){
            _send({
              "verb":"passive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "users":_choosingUsers,
                  "character":_selectCharacter
                }
              }
            });
          }else if(_sm.body["character"] == "厨师" || _sm.body["character"] == "共情者"){
            _send({
              "verb":"passive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "neighborNumber":_inputNumber
                }
              }
            });
          }else if(_sm.body["character"] == "送葬者"){
            _send({
              "verb":"passive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "user":_choosingUsers[0],
                  "character":_selectCharacter
                }
              }
            });
          }
          break;
        case "proactive_information_need":
          if(_sm.body["character"] == "占卜师"){
            _send({
              "verb":"proactive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "users":_sm.body["argument"]["users"],
                  "isThereADevil":_selectedBool
                }
              }
            });
          }else if(_sm.body["character"] == "渡鸦守护者"){
            _send({
              "verb":"proactive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "user":_sm.body["argument"]["user"],
                  "character":_selectCharacter
                }
              }
            });
          }
          else if(_sm.body["character"] == "小恶魔"){
            _send({
              "verb":"proactive_information_give",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "information":{
                  "state":"confirm",
                  "kill_user":_game.poisonedUser==_sm.body["seat_number"]?-1:_sm.body["information"]["kill_user"],
                  "new_imp":_choosingUsers.length==0?_sm.body["seat_number"]:_choosingUsers[0]
                }
              }
            });
          }
          break;
      }
    }else { //不是房主
      switch(_sm.verb){
          case "proactive_argument_need":
            if(_sm.body["character"] == "占卜师"){
                _send({
                "verb":"proactive_information_need",
                "body":{
                  "seat_number":_sm.body["seat_number"],
                  "character":_sm.body["character"],
                  "argument":{
                    "users":_choosingUsers
                  }
                }
              });
            }else if(_sm.body["character"] == "渡鸦守护者"){
              _send({
              "verb":"proactive_information_need",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "argument":{
                  "user":_choosingUsers[0]
                }
              }
            });
            }else if(_sm.body["character"] == "管家"){
              _send({
                "verb":"proactive_information_need",
                "body":{
                  "seat_number":_sm.body["seat_number"],
                  "character":_sm.body["character"],
                  "argument":{
                    "master_user":_choosingUsers[0]
                  }
                }
              });
            }else if(_sm.body["character"] == "投毒者"){
              _send({
                "verb":"proactive_information_need",
                "body":{
                  "seat_number":_sm.body["seat_number"],
                  "character":_sm.body["character"],
                  "argument":{
                    "poison_user":_choosingUsers[0]
                  }
                }
              });
            }else if(_sm.body["character"] == "僧侣"){
              _send({
              "verb":"proactive_information_need",
              "body":{
                "seat_number":_sm.body["seat_number"],
                "character":_sm.body["character"],
                "argument":{
                  "protect_user":_choosingUsers[0]
                }
              }
            });
            }else if(_sm.body["character"] == "小恶魔"){
              _send({
                "verb":"proactive_information_need",
                "body":{
                  "seat_number":_sm.body["seat_number"],
                  "character":_sm.body["character"],
                  "argument":{
                    "kill_user":_choosingUsers[0]
                  }
                }
              });
            }
          break;
        }
    }
    Navigator.of(context).pop();
  }

  void _dealImpKill(){
    int userSeat = _sm.body["argument"]["kill_user"];
    if(_game.poisonedUser == _sm.body["seat_number"]){
      _maxUser = 0;
      _hint = "小恶魔今晚中毒，无法鲨人";
      return;
    }
    if(_game.seats[userSeat].character == "市长" && _game.seats[userSeat].isAlive && _game.poisonedUser!=userSeat){
      _maxUser = 1;
      _hint = "请选择为市长挡刀的玩家";
    }else if(_sm.body["seat_number"] == userSeat){
      _maxUser = 1;
      _hint = "小恶魔自杀，请选择新的小恶魔";
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
                  label: Text("玩家 $userNumber ${_game.ishomeOwner?("(${this._game.seats[userNumber].character})"):""}${_game.seats[userNumber].name}"),
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
            Column(
                children: <ChoiceChip>[
                  ChoiceChip(
                      label:Text("有"),
                    selected: _selectedBool == true,
                    onSelected: (isSelected){
                        setState(() {
                          _selectedBool = true;
                        });
                    },
                  ),ChoiceChip(
                    label:Text("无"),
                    selected: _selectedBool == false,
                    onSelected: (isSelected){
                      setState(() {
                        _selectedBool = false;
                      });
                    },
                  )
                ]
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value){
                _inputNumber = int.parse(value);
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,//数字，只能是整数
              ],
            ),
            ElevatedButton(
              onPressed:(){
                _closeDialog();
              },
              child: Text('确定'),
            ),
          ],
        ),
      ),
    );
  }
}

class FlatButton {
}