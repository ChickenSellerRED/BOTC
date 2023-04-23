class GameSetting{
  late List<String> townsfolk;
  late List<String> outsiders;
  late List<String> minions;
  late List<String> demons;
  late List<String> bluff;
  late int foe;
  late String drunkFakeCharacter;
  late String spyFakeCharacter;
  late String recluseFakeCharacter;

  GameSetting(
      this.townsfolk,
      this.outsiders,
      this.minions,
      this.demons,
      this.bluff,
      this.foe,
      this.drunkFakeCharacter,
      this.spyFakeCharacter,
      this.recluseFakeCharacter);

  GameSetting.buildDefault(){
    townsfolk=["占卜师","僧侣","圣女"];
    outsiders=[];
    minions=["投毒者"];
    demons=["小恶魔"];
    bluff=["市长","士兵","图书管理员"];
    foe=1;
    drunkFakeCharacter="无";
    spyFakeCharacter="无";
    recluseFakeCharacter="无";
  }
  
  dynamic toJSON(){
    return {
      "townsfolk":townsfolk,
      "outsiders":outsiders,
      "minions":minions,
      "demons":demons,
      "bluff":bluff,
      "foe":1,
      "drunkFakeCharacter":drunkFakeCharacter,
      "spyFakeCharacter":spyFakeCharacter,
      "recluseFakeCharacter":recluseFakeCharacter,
    };
  }
}