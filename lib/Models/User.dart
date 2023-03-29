import 'dart:ui';
import 'package:uuid/uuid.dart';

class User{
  String _name;
  String _avatarUri;
  Uuid? _uuid;

  User(this._name, this._avatarUri){
    _uuid = const Uuid();
  }

  String get name => _name;
}