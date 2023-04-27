import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget{

  final double w;
  final double h;


  MessageList(this.w, this.h);

  @override
  State<StatefulWidget> createState() => MessageListState();

}
class MessageListState extends State<MessageList>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.w,
      height: widget.h,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
      ),
    );
  }

}