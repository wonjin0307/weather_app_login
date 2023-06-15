import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/method/weather.dart';
import 'package:flutterapp/screen/weather_screen.dart';

class LoadingScreen extends StatefulWidget{
  const LoadingScreen({super.key});



  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>{
  // 위젯이 생성될때 처음으로 호출되는 메서드 이면서도 생명주기에서 사용되는 메서드
  // 주로 생성된 위젯 인스턴스의 buildcontext에 의존적인 것들의 데이터 초기화를 할때 사용된다.
  @override
  void initState(){
    super.initState();
    getLocationData();
  }
  
// getLocationWeather에서 해당 날씨 데이터를 가져와서 weatherdata에 넣는다.
// 네비게이터 push를 사용하여 return 값인 locationScreen으로 이동하는데 weatherdata를 locationweather에 할당하여 입력값을 넘겨준다.
  void getLocationData() async{
    
    var weatherData = await WeatherModel().getLocationWeather();
    // print("__________________________");
    // print(weatherData[0]);

    var parse2amData = weatherData[0];
    var parseShortTermWeatherData = weatherData[1];
    var parseCurrentWeatherData = weatherData[2];
    var parseSuperShortWeatherData = weatherData[3];
    var parseAirConditionData = weatherData[4];
    var parseAddData = weatherData[5];

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,MaterialPageRoute(builder: (context){
        return WeatherScreen(star2amData: parse2amData,
        starShortTermWeatherData: parseShortTermWeatherData,
        starCurrentWeatherData: parseCurrentWeatherData,
        starSuperShortWeatherData: parseSuperShortWeatherData,
        starAirConditionData: parseAirConditionData,
        starAddrData:  parseAddData);
      }),
    );
  }

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body:Center(
        child:SpinKitDoubleBounce(
          color:Colors.white,
        ),
      ),
    );
  }
}