import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/api/auth/auth_api.dart';
import 'package:flutterapp/screen/weather_screen.dart';
import '../models/user_cubit.dart';
import '../models/user_models.dart';
import '../theme.dart';
import '../widgets/fields.dart';
import '../widgets/passwordfields.dart';
import '../widgets/text_button.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

  @override
    void initState() {
      super.initState();
    }

  @override
    void dispose() {
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, //appBar 투명색
        elevation: 0.0, //그림자 농도
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/setting/Orion_indicator-left1.svg',
            width: 80.0,
            height: 80.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          SizedBox(
            height: 155,
          ),
          CustomField(
            controller: emailController,
            iconUrl: 'assets/icon_email.png',
            hint: 'Email',
          ),
          PasswordcustomField(
            controller: passwordController,
            iconUrl: 'assets/icon_password.png',
            hint: 'Password',
          ),
          CustomTextButton(
            onTap: () async {
              var authRes = await userAuth(emailController.text,passwordController.text);
              if(authRes.runtimeType==String){
                showDialog(context: context, builder:(context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width:  250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[400],
                      ),
                      child: Text("아이디 비밀번호를 확인해주세요.",style:TextStyle(color:Colors.white))),
                  );
                },);
              } else if (authRes.runtimeType == User) {
                // user 안에 사용자의 상세정보가 들어가있다.
                User user = authRes;
                // emit()-> 상태 업데이트
                // context.read<UserCubit>().emit(user); 이걸 사용했지만
                // 구글링을 통해 아래 코드로 작성 해당 로직은 UserCubit에 있는
                BlocProvider.of<UserCubit>(context).emit(user);
                Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context){
                    return WeatherScreen();
                  }
                  ));
              }   
            },
            title: '로그인',
            margin: EdgeInsets.only(top: 50),
          ),
        ],
      ),
    );
  }
}

