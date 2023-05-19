import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockImgButton extends StatefulWidget{

  final IconData icons;
  final int unReadNumber;
  void Function()? onPress;


  BlockImgButton(this.icons, this.unReadNumber,{super.key,this.onPress});

  @override
  State<StatefulWidget> createState() => BlockImgButtonState();

}
class BlockImgButtonState extends State<BlockImgButton>{

  late IconData _icons;
  late int _unReadNumber;
  void Function()? _onPress;
  @override
  void initState() {
    super.initState();
    _icons = widget.icons;
    _unReadNumber = widget.unReadNumber;
    _onPress = widget.onPress;
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: Icon(_icons),
          onPressed: () {
            this._onPress!();
          },
        ),
        _unReadNumber > 0 ? Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              _unReadNumber.toString(),
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ):Container(),
      ],
    );
  }

}