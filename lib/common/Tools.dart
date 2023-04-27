import 'dart:convert';

class Tools{
  static Map json2Map(dynamic event){
    return jsonDecode(event as String);
  }

  static String toAvatarName(String character){
    switch (character){
      case "洗衣妇":
        return "washerwoman";
      case "图书管理员":
        return "librarian";
      case "调查员":
        return "investigator";
      case "厨师":
        return "chef";
      case "共情者":
        return "empath";
      case "送葬者":
        return "undertaker";
      case "占卜师":
        return "fortune_teller";
      case "僧侣":
        return "monk";
      case "渡鸦守护者":
        return "ravenkeeper";
      case "圣女":
        return "virgin";
      case "市长":
        return "mayor";
      case "士兵":
        return "soldoer";
      case "杀手":
        return "slayer";
      case "隐士":
        return "recluse";
      case "圣徒":
        return "saint";
      case "酒鬼":
        return "drunk";
      case "管家":
        return "butler";
      case "小恶魔":
        return "imp";
      case "间谍":
        return "spy";
      case "红唇女郎":
        return "scarlet_woman";
      case "男爵":
        return "baron";
      case "投毒者":
        return "poisoner";
    }
    return "default";
  }

}