import '../Models/User.dart';

class Global{
  static late User userProfile;
  static bool isLoggedIn = false;
  static late UserLab userLab;
  static bool isOnline = false;
  static late dynamic channel;

  static Future init() async {
    userProfile = User("Mayor", "images/avatar.png");
    userLab = UserLab();
    print("app start");
    return;
  }


}

class UserLab{
  late List<User> _users;

  UserLab(){
    _users = <User>[];
    for(int i=0;i<10;i++){
      _users.add(User("user_"+i.toString(),"images/avatar.png"));
    }
  }
  int count(){
    return _users.length;
  }
  User getUser(int index){
    return _users[index];
  }
}