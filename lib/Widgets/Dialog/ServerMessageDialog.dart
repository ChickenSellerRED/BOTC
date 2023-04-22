import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/ServerMessage.dart';

class ServerMessageDialog extends StatefulWidget{

  final ServerMessage _sm;


  ServerMessageDialog(this._sm);

  @override
  State createState() => ServerMessageDialogState();
}
class ServerMessageDialogState extends State<ServerMessageDialog>{

  late ServerMessage _sm;
  @override
  void initState() {
    super.initState();
    _sm = widget._sm;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(

    );
  }
}

class FlatButton {
}