import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/style/constatns.dart';
import 'package:flutterapp/style/constatns.dart';

class login_screen extends StatefulWidget {
  @override
  _login_screenstate createState() => _login_screenstate();
}

class _login_screenstate extends State<login_screen> {
  late String cityName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, //appBar 투명색
        elevation: 0.0, //그림자 농도
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/setting/Orion_back.svg',
            width: 35.0,
            height: 35.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Stack(children: [
          Image.asset(
            'assets/cool-background.png',
            fit: BoxFit.cover, //지정된 영역을 꽉 채운다
            width: double.infinity, //가로 너비 채우기
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Container(
              padding:EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container( 
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 200.0,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(             
                                decoration: const InputDecoration(
                                  labelText: 'ID',
                                  border: OutlineInputBorder(),
                                  // enabledBorder 가 들어간다면 border 는 무시됩니다.
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                    color: Colors.green,
                                  ))
                                ),
                              ),
                              SizedBox(height: 12.0),
                              TextFormField(      
                                obscureText: true,       
                                decoration: const InputDecoration(
                                  labelText: 'PASSWORD',
                                  border: OutlineInputBorder(),
                                  // enabledBorder 가 들어간다면 border 는 무시됩니다.
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                    color: Colors.green,
                                  ))
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(                  
                      ),
                ]),
              ],)
            ),
          ),
      ])),
    );
  }
}

