import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/User.dart';
import 'UserCardWidget.dart';

class UserLayoutWidget extends StatefulWidget{


  final List<User> seats;
  final List<int> seatNumber;
  final Function(int,int) onSeatsSwitch;

  const UserLayoutWidget(this.seats, this.seatNumber,this.onSeatsSwitch, {super.key});

  @override
  State<StatefulWidget> createState() => UserLayoutWidgetState();

}

class UserLayoutWidgetState extends State<UserLayoutWidget>{


  late List<User> _seats;
  late List<int> _seatNumber;
  late Function(int,int) _onSeatsSwitch;

  @override
  void initState() {
    super.initState();
    _seats = widget.seats;
    _seatNumber = widget.seatNumber;
    _onSeatsSwitch = widget.onSeatsSwitch;
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
                children: List<Widget>.generate(15, (index) =>
                _seatNumber.contains(index)?Positioned(
                    left:_getUserCardPosition(index,false),
                    top:_getUserCardPosition(index,true),
                    child:DragTarget<User>(
                      builder: (context,data,rejectedData){
                        return LongPressDraggable(
                          maxSimultaneousDrags: _seats[index].isDefault()?0:1,
                          data: _seats[index],
                          feedback: Opacity(opacity:.45,child:Material(child:UserCardWidget(_seats[index],-1))),
                          child: UserCardWidget(_seats[index],_seatNumber.indexOf(index)+1),
                        );
                      },
                      onWillAccept: (data){
                        return true;
                      },
                      onAccept: (data){
                        int target = -1;
                        for(int i=0;i<_seats.length;i++){
                          if(data.equals(_seats[i])){
                            target = i;
                            break;
                          }
                        }
                        if(target != -1){
                          //找到了
                          print("index:"+index.toString());
                          print("target:"+target.toString());
                          print(_seats[index].name);
                          print(_seats[target].name);
                          _onSeatsSwitch(target,index);

                        }else if(target == -1){
                          //todo:处理seats找不到该user的情况（比如user恰好退出房间）
                        }
                      },)
                ):Container()

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
  
}