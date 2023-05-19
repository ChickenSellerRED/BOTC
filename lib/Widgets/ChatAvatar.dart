import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String _avatarUri;
  final bool _isChosen;
  final _unReadNumber;


  ChatAvatar(this._avatarUri, this._isChosen,this._unReadNumber);


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: _isChosen
                ? Border.all(color: Color(0xFF90CAF9), width: 3)
                : Border.all(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                border: _isChosen
                    ? Border.all(color: Colors.white, width: 2)
                    : Border.all(color: Colors.white, width: 0),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: AssetImage(_avatarUri)
                )
            ),
            // child: Image(image: AssetImage(_avatarUri))

          ),
        ),
      ),
        _unReadNumber>0?Positioned(
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
