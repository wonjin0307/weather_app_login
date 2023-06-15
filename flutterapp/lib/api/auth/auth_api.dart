import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/user_models.dart';
const baseUrl="http://127.0.0.1:8000";
//  (  + Hive는 그냥 flutter dart 언어에서 사용되는 NoSQL 형식의 데이터베이스)
  //  애뮬레이터를 사용하면 URI 10.0.2.2를 사용하게되는데 컴퓨터 사양이 애뮬레이터를 돌릴수없을정도로 렉이 심하게 걸려서
  //  CHROME 웹 브라우저를 사용하여 앱을 구현중인데, 웹 브라우저의 보안이 엄청 높아서 그 보안을 좀 풀어줘야한다.
  //  그래서 백에서는 CORS 를 통하여 모든 이용자를 허용하게 해주고, CHROME.dart 에서 시큘리티를 끄는 코드를 넣어서 프론트와 백에 보안성을 낮추는 코드를 작성하였다.
Future<dynamic> userAuth(String email , String password) async {
  Map body = {
    // "username":"",
    "email":email,
    "password":password
  };
  
  var url = Uri.parse("$baseUrl/user/auth/login/");
  var res = await http.post(url, body:body);
  
  print(res.body);
  // 응답이 성공하면 200이 넘어오고 실패시 400번대 넘어온다.
  print(res.statusCode);

  if(res.statusCode == 200){

    Map json=jsonDecode(res.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    box.put("token", token);
    User? user = await getUser(token);
    return user;
  }
  else{
    
    Map json=jsonDecode(res.body);
    print(json);
    if(json.containsKey("email")){
      return json["email"][0];
    }
    if(json.containsKey("password")){
      return json["password"][0];
    }
    if(json.containsKey("non_field_errors")){
      return json["non_field_errors"][0];
    }
  }
}

// 토큰 값으로 로그인 사이트에 들어가면서 넘겨준다 그래서 해당 토큰값때문에 권한을 얻게되고, 사용자 정보를 가져올수있게 되는것이다.
Future<User?> getUser(String token) async{
  var url=Uri.parse("$baseUrl/user/auth/user/");
  var res = await http.get(url,headers: {
    'Authorization': 'Token ${token}',
  });
  if(res.statusCode==200){
    //  디코딩을할때 한글 깨짐 현상 제거 
  var json = jsonDecode(utf8.decode(res.bodyBytes));
  print(json);
  User user = User.fromJson(json);
  user.token = token;
  return user;
  }
  else{
    return null;
  }
}



//test1@gmail.com
// dksrud@12이다.