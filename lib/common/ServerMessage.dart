class ServerMessage{
  late String verb;
  late dynamic body;

  ServerMessage(this.verb, this.body);

  log(){
    print(this.verb);
    print(this.body);
  }
}