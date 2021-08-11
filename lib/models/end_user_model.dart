class EndUser {

  String username;
  String password;

  EndUser({this.username,this.password});

  Map<String,dynamic> toMap() {
    var map = <String, dynamic>{
      'username' : username,
      'password' : password
    };
    return map;
  }

  EndUser.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    password = map['password'];
  }
}