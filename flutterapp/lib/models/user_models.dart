// 로컬 저장소
// key 값을 저장한다.

class User{
  int? id;
  String? token;
  String? username;
  String? email,first_name,last_name;
  User({
    this.email,
    this.first_name,
    this.last_name,
    this.id,
    this.username,
  });

  factory User.fromJson(json){
    print(json["first_name"]);
    return User(
      email: json["email"],
      first_name: json["first_name"],
      id: json["pk"],
      last_name: json["last_name"],
      username: json["username"],
    );
  }
  // {"{"pk":14,"username":"","email":"test1@gmail.com","first_name":"Jung","last_name":"wonjin"}"}
}
