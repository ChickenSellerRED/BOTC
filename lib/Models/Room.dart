import 'dart:math';
import 'package:my_flutter_app/Models/User.dart';
import 'package:uuid/uuid.dart';

class Room{
  User _homeOwner;
  int _maxpeople;
  String _name;
  int _roomNumber;

  Room(this._homeOwner,this._maxpeople,this._name,this._roomNumber);

  String get name => _name;

  User get homeOwner => _homeOwner;

  int get maxpeople => _maxpeople;

  int get roomNumber => _roomNumber;

  Room.buildFromJSON(dynamic json):
    _homeOwner  = User.buildFromJSON(json["homeOwner"]),
    _maxpeople  = json["maxPeople"],
    _name       = json["name"],
    _roomNumber = json["roomNumber"];

  Room.buildDefault():
    _homeOwner = User.buildDefault(),
    _maxpeople = 10,
    _name = "     ",
    _roomNumber = -1;

}