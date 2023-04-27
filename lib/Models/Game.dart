import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/Models/GameSetting.dart';

import '../Pages/GamePage.dart';
import '../common/ServerMessage.dart';
import '../common/Tools.dart';
import 'User.dart';

class Game{
  late int maxPeople;
  late List<User> seats;
  late int days = 0;//游戏天数
  late Stage state = Stage.night;//当前游戏的阶段
  bool _isNightNow() => state==Stage.night;//现在是否是晚上
  late User nominatingUser = User.buildDefault();//正在被提名的玩家
  late Map<User,int> nominees = Map();//在处刑台上的所有玩家以及票数
  late User executingUser = User.buildDefault();//将被处刑的玩家
  late List<String> gameLog = List<String>.empty();//游戏日志
  late Queue<ServerMessage> sMessages = Queue<ServerMessage>();


  late int monkProtect = -1;//整数 在这一轮被保护的玩家
  late int butlerMaster = -1;//整数 在这一轮管家的主人
  late int poisonedUser = -1;//整数 在这一轮被毒的玩家 // 添加中毒信息到user中
  late int beKilledUser = -1;//整数 在这一轮被杀的玩家

  late GameSetting gameSetting;

  late int voteFrom;
  late int voteTo;

  late bool ishomeOwner;
  //说书人专用
  late List<String> characters; //根据座位排序的角色信息


  Game.createNew(){
    voteFrom = -1;
    voteTo = -1;
  }
  void config(GameSetting gs){
    gameSetting = gs;
  }

  void assignCharacters(){
    for(int i=0;i<characters.length;i++){
      seats[i].character = characters[i];
      seats[i].avatarUri = "images/character_avatar/Icon_" + Tools.toAvatarName(characters[i]) + ".png";
    }
  }

}