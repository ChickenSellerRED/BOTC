import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/Game.dart';
import '../Models/User.dart';
import 'UserCardWidget.dart';

class UserLayoutWidget extends StatefulWidget{


  late Game game;
  final bool isWaitting;
  final bool isGaming;
  final bool isChoosing;
  final List<int> choosingUsers;
  void Function(int,int)? onSeatsSwitch;
  void Function(int)? onClickCard;


  UserLayoutWidget(this.game, {this.onClickCard,this.onSeatsSwitch,super.key,this.isWaitting=false,this.isGaming=false,this.isChoosing=false,this.choosingUsers=const <int>[],}){

  }

  @override
  State<StatefulWidget> createState() => UserLayoutWidgetState();

}

class UserLayoutWidgetState extends State<UserLayoutWidget>{
  
  late List<int> _seatNumber;
  late Game _game;
  late bool _isWaiting;
  late bool _isGaming;
  late bool _isChoosing;
  late List<int> _choosingUsers;
  void Function(int,int)? _onSeatsSwitch;
  void Function(int)? _onClickCard;

  @override
  void initState() {
    super.initState();
    _game = widget.game;
    _onSeatsSwitch = widget.onSeatsSwitch;
    _isWaiting = widget.isWaitting;
    _isGaming = widget.isGaming;
    _isChoosing = widget.isChoosing;
    _choosingUsers = widget.choosingUsers;
    _onClickCard = widget.onClickCard;
    _initSeatNumber(_game.seats.length);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
        ),
        child:SizedBox(
            width: 357,
            height: 373,
            child:Stack(
                alignment: Alignment.topLeft,
                children: List<Widget>.generate(_game.seats.length, (index){
                  int layoutIndex = _seatNumber[index];
                return Positioned(
                    left:_getUserCardPosition(layoutIndex,false),
                    top:_getUserCardPosition(layoutIndex,true),
                    child:GestureDetector(
                      onTap: (){
                        if(this._isChoosing)
                          this._onClickCard!(index);
                      },
                      child:Container(
                          decoration: BoxDecoration(
                              border:Border.all(color: Colors.amberAccent,width: _choosingUsers.contains(index)?3:0)
                          ),
                          child:DragTarget<User>(
                            builder: (context,data,rejectedData){
                              return LongPressDraggable(
                                maxSimultaneousDrags: !_isWaiting?0:_game.seats[index].isDefault()?0:1,
                                data: _game.seats[index],
                                feedback: Opacity(opacity:.45,child:Material(child:UserCardWidget(_game.seats[index],-1))),
                                child: UserCardWidget(_game.seats[index],index+1),
                              );
                            },
                            onWillAccept: (data){
                              return true;
                            },
                            onAccept: (data){
                              int target = -1;
                              for(int i=0;i<_game.seats.length;i++){
                                if(data.equals(_game.seats[i])){
                                  target = i;
                                  break;
                                }
                              }
                              if(target != -1 && target != index){
                                //找到了
                                _onSeatsSwitch!(target,index);
                              }else if(target == -1){
                                //todo:处理seats找不到该user的情况（比如user恰好退出房间）
                              }
                            },))
                    )
                )
                ;}

                )

            )

        ));
  }

  double _getUserCardPosition(int index, bool isTop){
    var left = [146,219,292,292,292,292,292,195,98,0,0,0,0,0,73];
    var top = [0,0,0,77,154,231,308,308,308,308,231,154,77,0,0];
    if(isTop){
      return top[index]+0.0;
    }else{
      return left[index]+0.0;
    }
  }
  void _initSeatNumber(int number){
    print("_initSeatNumber");
    switch(_game.maxPeople){
      case 5:
        _seatNumber = [0,4,7,8,11];
        break;
      case 6:
        _seatNumber = [1,4,7,8,11,14];
        break;
      case 7:
        _seatNumber = [0,1,4,7,8,11,14];
        break;
      case 8:
        _seatNumber = [0,1,3,4,7,8,11,14];
        break;
      case 9:
        _seatNumber =  [0,1,3,4,7,8,11,12,14];
        break;
      case 10:
        _seatNumber = [0,1,3,4,5,7,8,11,12,14];
        break;
      case 11:
        _seatNumber = [0,1,3,4,5,7,8,10,11,12,14];
        break;
      case 12:
        _seatNumber = [0,1,3,4,5,6,7,8,10,11,12,14];
        break;
      case 13:
        _seatNumber = [0,1,3,4,5,6,7,8,9,10,11,12,14];
        break;
      case 14:
        _seatNumber = [0,1,2,3,4,5,6,7,8,9,10,11,12,14];
        break;
      case 15:
        _seatNumber = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
        break;
      default:
        break;

    }

  }
  
}