import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/screen/loading_screen.dart';
import 'package:intl/intl.dart';
import '../method/location.dart';
import 'package:flutterapp/method/networking.dart';

// 외부 날씨 APIKEY
// 날씨 오픈 API를 가져오기위한 URL부분을 openWeatherMapURL에 할당한다. API를 사용할때마다 이부분을 반복적으로 사용해야되니깐
// 변수지정을 해줬다.
const apiKey = '9wZ%2BrDU8Rw9aGoABTm8p6z3qEOHzGQIcxScp0YEj%2FdRlKNreVbpR2QNFbYWB%2F%2B6CGT3PhJKUMclAZ59a5JV2mA%3D%3D';

// const kakaoApiKey = '9cc0f83bb5119f7f7a401f465153f498';


class WeatherModel{
  // getLocationWeather메서드: 사용자 위치에 따른 날씨 정보를 넘겨주는 메서드
  Future<dynamic>getLocationWeather() async{
    // 변수 선언
    String? baseTime;
    String? baseDate;
    String? baseDate_2am;
    String? baseTime_2am;
    String? currentBaseTime; //초단기 실황
    String? currentBaseDate;
    String? sswBaseTime; //초단기 예보
    String? sswBaseDate;

    int? xCoordinate;
    int? yCoordinate;
    double? userLati;
    double? userLongi;

    var tm_x;
    var tm_y;

    var obsJson;
    var obs;
    dynamic Weathers;
    var now = DateTime.now();  // 현재 시간

    // getCurrentLocation()을 사용하여 현재 위치에 대한 정보 가져온다.
    Location location = Location();
    await location.getCurrentLocation();
    xCoordinate = location.currentX;  //x좌표
    yCoordinate = location.currentY;  //y좌표
    userLati = location.latitude; //위도
    userLongi = location.longitude; //경도


    print(xCoordinate);
    print(yCoordinate);

    //오늘 날짜 20230525 형태로 리턴한다.
    String getSystemTime(){
      return DateFormat("yyyyMMdd").format(now);
    }

    //어제 날짜 20230524 형태로 리턴한다.
    String getYesterdayDate(){
      return DateFormat("yyyyMMdd").format(DateTime.now().subtract(const Duration(days:1)));
    }

    if(now.hour < 2 || now.hour == 2 && now.minute < 10){
      baseDate_2am = getYesterdayDate();
      baseTime_2am = "2300";
    } else {
      baseDate_2am = getSystemTime();
      baseTime_2am = "0200";
    }
    // print(baseDate_2am);
    // print(baseTime_2am);

    //단기 예보 시간별 baseTime, baseDate
    void shortWeatherDate(){
      if(now.hour < 2 || (now.hour == 2 && now.minute <= 10)){ //0시~2시 10분 사이 예보
        baseDate = getYesterdayDate();   //어제 날짜
        baseTime = "2300";
      } else if (now.hour < 5 || (now.hour == 5 && now.minute <= 10)){ //2시 11분 ~ 5시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "0200";
      } else if (now.hour < 8 || (now.hour == 8 && now.minute <= 10)){ //5시 11분 ~ 8시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "0500";
      } else if (now.hour < 11 || (now.hour == 11 && now.minute <= 10)){ //8시 11분 ~ 11시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "0800";
      } else if (now.hour < 14 || (now.hour == 14 && now.minute <= 10)){ //11시 11분 ~ 14시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "1100";
      } else if (now.hour < 17 || (now.hour == 17 && now.minute <= 10)){ //14시 11분 ~ 17시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "1400";
      } else if (now.hour < 20 || (now.hour == 20 && now.minute <= 10)){ //17시 11분 ~ 20시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "1700";
      } else if (now.hour < 23 || (now.hour == 23 && now.minute <= 10)){ //20시 11분 ~ 23시 10분 사이 예보
        baseDate = getSystemTime();
        baseTime = "2000";
      } else if (now.hour == 23 && now.minute >= 10){ //23시 11분 ~ 24시 사이 예보
        baseDate = getSystemTime();
        baseTime = "2300";
      }
    }

    //초단기 실황
    void currentWeatherDate() {
      //40분 이전이면 현재 시보다 1시간 전 `base_time`을 요청한다.
      if (now.minute <= 40){
        // 단. 00:40분 이전이라면 `base_date`는 전날이고 `base_time`은 2300이다.
        if (now.hour == 0) {
          currentBaseDate = DateFormat('yyyyMMdd').format(now.subtract(const Duration(days:1)));
          currentBaseTime = '2300';
        } else {
          currentBaseDate = DateFormat('yyyyMMdd').format(now);
          currentBaseTime = DateFormat('HH00').format(now.subtract(const Duration(hours:1)));
        }
      }
      //40분 이후면 현재 시와 같은 `base_time`을 요청한다.
      else{
        currentBaseDate = DateFormat('yyyyMMdd').format(now);
        currentBaseTime = DateFormat('HH00').format(now);
      }
    }

    //초단기 예보
    void superShortWeatherDate(){
      //45분 이전이면 현재 시보다 1시간 전 `base_time`을 요청한다.
      if (now.minute <= 45){
        // 단. 00:45분 이전이라면 `base_date`는 전날이고 `base_time`은 2330이다.
        if (now.hour == 0) {
          sswBaseDate = DateFormat('yyyyMMdd').format(now.subtract(const Duration(days:1)));
          sswBaseTime = '2330';
        } else {
          sswBaseDate = DateFormat('yyyyMMdd').format(now);
          sswBaseTime = DateFormat('HH30').format(now.subtract(const Duration(hours:1)));
        }
      }
      //45분 이후면 현재 시와 같은 `base_time`을 요청한다.
      else{ //if (now.minute > 45)
        sswBaseDate = DateFormat('yyyyMMdd').format(now);
        sswBaseTime = DateFormat('HH30').format(now);
      }
    }

    //오늘 최저 기온
    String today2am = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'
        'serviceKey=$apiKey&numOfRows=1000&pageNo=1&'
        'base_date=$baseDate_2am&base_time=$baseTime_2am&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    shortWeatherDate();
    //단기 예보 데이터
    String shortTermWeather = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'
        'serviceKey=$apiKey&numOfRows=1000&pageNo=1&'
        'base_date=$baseDate&base_time=$baseTime&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    currentWeatherDate();
    //현재 날씨(초단기 실황)
    String currentWeather = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?'
        'serviceKey=$apiKey&numOfRows=10&pageNo=1&'
        'base_date=$currentBaseDate&base_time=$currentBaseTime&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    superShortWeatherDate();
    //초단기 예보
    String superShortWeather = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst'
        '?serviceKey=$apiKey&numOfRows=60&pageNo=1'
        '&base_date=$sswBaseDate&base_time=$sswBaseTime&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    //미세먼지 (에어코리아)
    String airConditon = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?'
        'stationName=$obs&dataTerm=DAILY&pageNo=1&ver=1.0'
        '&numOfRows=1&returnType=json&serviceKey=$apiKey';

    
    Network network = Network(today2am,shortTermWeather,currentWeather,superShortWeather,airConditon);
    
    var today2amData = await network.getToday2amData();
    var shortTermWeatherData = await network.shortTermWeatherData();
    var currentWeatherData = await network.currentWeatherData();
    var superShortWeatherData = await network.veryShortWeatherData();
    var airConditionData = await network.airConditionData();

    // 외부 API 에서 가져온 데이터 (일기예보,미세먼지)를 디코딩한 각 변수들을 Weathers에 넣어서
    // 배열형태로 리턴해준다. ( 여러개의 값들을 리턴해주고싶었는데, provider에 대한 개념을 완벽하게 익히지 못해서 사용했다.)
    Weathers = [today2amData,shortTermWeatherData,currentWeatherData,superShortWeatherData,airConditionData];
    return Weathers;
  }
}