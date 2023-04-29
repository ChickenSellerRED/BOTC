import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget{
  final String _avatarUri;
  final bool _isChosen;


  ChatAvatar(this._avatarUri, this._isChosen);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          border:_isChosen?Border.all(color: Color(0xFF90CAF9),width: 3):Border.all(color:Colors.white,width: 0),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                border:_isChosen?Border.all(color: Colors.white,width: 2):Border.all(color:Colors.white,width: 0),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:AssetImage(_avatarUri)
            )
            ),
            // child: Image(image: AssetImage(_avatarUri))

        ),
      ),
    );
  }

}
// class ChatAvatarState extends State<ChatAvatar>{
//   late String _avatarUri;
//   late bool _isChosen;
//   @override
//   void initState() {
//     // TODO: implement initState
//     _avatarUri = widget.avatarUri;
//     _isChosen = widget.isChosen;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 65,
//         height: 65,
//       decoration: BoxDecoration(
//         border:_isChosen?Border.all(color: Colors.greenAccent,width: 15):Border.all(width: 0)
//       ),
//       child: Center(
//         child: Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//               border:_isChosen?Border.all(color: Colors.white,width: 2):Border.all(width: 0)
//           ),
//           child: Image(image: AssetImage(_avatarUri))
//         ),
//       ),
//     );
//   }
// }