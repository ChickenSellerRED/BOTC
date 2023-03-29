import 'dart:math';
import 'package:my_flutter_app/Models/User.dart';
import 'package:uuid/uuid.dart';

class Room{
  User _homeOwner;
  int _maxpeople;
  String _name;
  late int _roomNumber;


  void _generateRoomNumber(){
    _roomNumber = Random().nextInt(100000000);
  }
  Room(this._homeOwner,this._maxpeople,this._name) {
    _generateRoomNumber();
  }

  String get name => _name;

  User get homeOwner => _homeOwner;
}