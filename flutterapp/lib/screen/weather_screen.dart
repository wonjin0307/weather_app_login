import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterapp/style/constatns.dart';
import 'package:flutterapp/method/weather.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutterapp/style/model.dart';
import 'package:timer_builder/timer_builder.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen(
      {this.star2amData,
      this.starShortTermWeatherData,
      this.starCurrentWeatherData,
      this.starSuperShortWeatherData,
      this.starAirConditionData,
      this.starAddrData});
  final dynamic star2amData;
  final dynamic starShortTermWeatherData;
  final dynamic starCurrentWeatherData;
  final dynamic starSuperShortWeatherData;
  final dynamic starAirConditionData;
  final dynamic starAddrData;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Model model = Model();

  var now = DateTime.now();
  var timeHH; //현재 시간 HH00
  late DateFormat daysFormat; //요일 한글로

  var todayTMX2; //일 최고기온
  var todayTMN2; //일 최저기온
  var parsed_json;
  int? todayTMX;
  int? todayTMN;

  var currentT1H; //현재 기온
  String? currentREH; //현재 습도
  String? currentRN1; //1시간 강수량

  var skyCode; //하늘코드
  var ptyCode; //강수코드
  late Widget skyIcon; //날씨 아이콘
  late Widget skyDesc; //날씨 설명

  var air10; //미세먼지
  var air25; //초미세먼지
  late Widget airIcon; //미세먼지 아이콘
  late Widget airDesc;
  late Widget airIcon25; //미세먼지 아이콘
  late Widget airDesc25;

  String? where; //인천, 서울과 같은 큰 특별시 명칭
  String? si; //시
  String? addr; //동

  //시간대별 날씨 변수
  var next1, next2, next3, next4,
  next5,next6,next7,next8
  ;
  var next1_TMP, next2_TMP, next3_TMP, next4_TMP,
  next5_TMP,next6_TMP,next7_TMP,next8_TMP
  ; //다음 기온
  late String next1_REH, next2_REH, next3_REH, next4_REH,
  next5_REH,next6_REH,next7_REH,next8_REH
  ; //다음 습도
  late String next1_time, next2_time, next3_time, next4_time,
  next5_time,next6_time,next7_time,next8_time
  ; // 다음 시간
  late String next1_PTY, next2_PTY, next3_PTY, next4_PTY,
  next5_PTY,next6_PTY,next7_PTY,next8_PTY
  ; //다음 pty 코드
  late String next1_SKY, next2_SKY, next3_SKY, next4_SKY,
  next5_SKY,next6_SKY,next7_SKY,next8_SKY
  ; //다음 SKY 코드
  late Widget current_icon,next1_icon,next2_icon,next3_icon,
  next4_icon,next5_icon,next6_icon,next7_icon,next8_icon
  ;
       // 다음 아이콘

  //3일간 날씨 변수
  String? today;
  String? tmr;
  String? df_tmr;
  String? tmr_REH; //내일 습도
  String? df_tmr_REH; //모레 습도
  int? tmr_tmn;
  int? tmr_tmx;
  int? df_tmr_tmn;
  int? df_tmr_tmx;
  var tmr_tmn2;
  var tmr_tmx2;
  var df_tmr_tmn2;
  var df_tmr_tmx2;
  late String td_sky_6,
      td_sky_18,
      tmr_sky_6,
      tmr_sky_18,
      df_tmr_sky_6,
      df_tmr_sky_18;
  late String td_pty_6,
      td_pty_18,
      tmr_pty_6,
      tmr_pty_18,
      df_tmr_pty_6,
      df_tmr_pty_18;
  late Widget td_icon_6,
      td_icon_18,
      tmr_icon_6,
      tmr_icon_18,
      df_tmr_icon_6,
      df_tmr_icon_18;

  String getSystemTime() {
    return DateFormat("h:mm a").format(now);
  }

  void initState() {
    super.initState();
    initializeDateFormatting();
    daysFormat = new DateFormat.EEEE('ko'); //요일 한글 표현
    updateData(
        widget.star2amData,
        widget.starShortTermWeatherData,
        widget.starCurrentWeatherData,
        widget.starSuperShortWeatherData,
        widget.starAirConditionData,
        widget.starAddrData);
  }

  void weatherTime() {
    if (now.hour < 3) {
      next1 = '0300';
      next2 = '0400';
      next3 = '0500';
      next4 = '0600';
      next5 = '0700';
      next6 = '0800';
      next7 = '0900';
      next8 = '1000';
    } else if (now.hour < 6) {
      next1 = '0600';
      next2 = '0700';
      next3 = '0800';
      next4 = '0900';
      next5 = '1000';
      next6 = '1100';
      next7 = '1200';
      next8 = '1300';
    } else if (now.hour < 9) {
      next1 = '0900';
      next2 = '1000';
      next3 = '1100';
      next4 = '1200';
      next5 = '1300';
      next6 = '1400';
      next7 = '1500';
      next8 = '1600';
    } else if (now.hour < 12) {
      next1 = '1200';
      next2 = '1300';
      next3 = '1400';
      next4 = '1500';
      next5 = '1600';
      next6 = '1700';
      next7 = '1800';
      next8 = '1900';
    } else if (now.hour < 15) {
      next1 = '1500';
      next2 = '1600';
      next3 = '1700';
      next4 = '1800';
      next5 = '1900';
      next6 = '2000';
      next7 = '2100';
      next8 = '2200';
    } else if (now.hour < 18) {
      next1 = '1800';
      next2 = '1900';
      next3 = '2000';
      next4 = '2100';
      next5 = '2200';
      next6 = '2300';
      next7 = '0000';
      next8 = '0100';
    } else if (now.hour < 21) {
      next1 = '2100';
      next2 = '2200';
      next3 = '2300';
      next4 = '0000';
      next5 = '0000';
      next6 = '0100';
      next7 = '0200';
      next8 = '0300';
    } else {
      next1 = '0000';
      next2 = '0100';
      next3 = '0200';
      next4 = '0300';
      next5 = '0400';
      next6 = '0500';
      next7 = '0600';
      next8 = '0700';
    }
    print('$next1 $next2 $next3 $next4 $next5 $next6 $next7 ');
    
  }

  String? timeDesc(next) {
    if (next == '0000') {
      return '0시';
    } else if (next == '0100' || next == '1300') {
      return '1시';
    } else if (next == '0200'|| next == '1400') {
      return '2시';
    } else if (next == '0300'|| next == '1500') {
      return '3시';
    } else if (next == '0400'|| next == '1600') {
      return '3시';
    } else if (next == '0500'|| next == '1700') {
      return '5시';
    } else if (next == '0600'|| next == '1800') {
      return '6시';
    } else if (next == '0700'|| next == '1900') {
      return '7시';
    } else if (next == '0800'|| next == '2000') {
      return '8시';
    } else if (next == '0900'|| next == '2100') {
      return '9시';
    } else if (next == '1000'|| next == '2200') {
      return '10시';
    } else if (next == '1100'|| next == '2300') {
      return '11시';
    } else if (next == '1200') {
      return '12시';
    } 
  }
  void updateData(
      dynamic today2amData,
      dynamic shortTermWeatherData,
      dynamic currentWeatherData,
      dynamic superShortWeatherData,
      dynamic airConditionData,
      dynamic addrData) {


    print(today2amData);
    today = DateFormat('yyyyMMdd').format(now);
    tmr = DateFormat('yyyyMMdd').format(now.add(Duration(days: 1)));
    df_tmr = DateFormat('yyyyMMdd').format(now.add(Duration(days: 2)));
    timeHH = DateFormat('HH00').format(now.add(Duration(minutes: 30)));

    print(today.toString());
    print(tmr.toString());
    print(df_tmr.toString());
    print(timeHH.toString());

    int totalCount = today2amData['response']['body']['totalCount']; //데이터의 총 갯수
    for (int i = 0; i < totalCount; i++) {
      //데이터 전체를 돌면서 원하는 데이터 추출
      parsed_json = today2amData['response']['body']['items']['item'][i];
      if (now.hour < 2) {
        //2시 이전, 23시 데이터
        if (parsed_json['category'] == 'TMN') {
          todayTMN2 = parsed_json['fcstValue'];
        }
        //당일 최고 기온
        if (parsed_json['category'] == 'TMX') {
          todayTMX2 = parsed_json['fcstValue'];
          break;
        }
      } else {
        //2시 이후
        //당일 최저 기온
        if (parsed_json['category'] == 'TMN' &&
            parsed_json['baseDate'] == parsed_json['fcstDate']) {
          todayTMN2 = parsed_json['fcstValue'];
        }
        //당일 최고 기온
        if (parsed_json['category'] == 'TMX' &&
            parsed_json['baseDate'] == parsed_json['fcstDate']) {
          todayTMX2 = parsed_json['fcstValue'];
        }
      }

      //오늘 오전, 오후 sky, pty 코드
      if (parsed_json['fcstDate'] == today) {
        if (parsed_json['fcstTime'] == '0600') {
          if (parsed_json['category'] == 'SKY') {
            td_sky_6 = parsed_json['fcstValue'];
          }
          if (parsed_json['category'] == 'PTY') {
            td_pty_6 = parsed_json['fcstValue'];
          }
        }
        if (parsed_json['fcstTime'] == '1800') {
          if (parsed_json['category'] == 'SKY') {
            td_sky_18 = parsed_json['fcstValue'];
          }
          if (parsed_json['category'] == 'PTY') {
            td_pty_18 = parsed_json['fcstValue'];
          }
        }
      }
    }
    td_icon_6 = model.getSkyIcon(td_sky_6, td_pty_6, 50, 50, '0600')!;
    td_icon_18 = model.getSkyIcon(td_sky_18, td_pty_18, 50, 50, '1800')!;
    //td_sky_18과 td_pty_18는 0시 ~ 2시 사이에 에러 발생한다. Json파일 자체 내에서의 문제 인거같다. 
    todayTMN = double.parse('$todayTMN2').round(); //반올림
    todayTMX = double.parse('$todayTMX2').round();

    //단기예보
    //내일, 모레 최고 최저 온도
    String timeHHString = timeHH.toString();
    int totalCount2 = shortTermWeatherData['response']['body']['totalCount'];
    print('_______________________________________________');
    print(shortTermWeatherData['response']['body']['items']['item']);


    weatherTime();
    for (int i = 0; i < totalCount2; i++) {
      //데이터 전체를 돌면서 원하는 데이터 추출
      parsed_json = shortTermWeatherData['response']['body']['items']['item'][i];
      //기온 & 시간
      if (parsed_json['category'] == 'TMP' &&
          (parsed_json['fcstDate'] == today ||
              parsed_json['fcstDate'] == tmr)) {
        if (parsed_json['fcstTime'] == next1) {
          next1_TMP = parsed_json['fcstValue'];
          next1_time = timeDesc(next1)!;
        }
        if (parsed_json['fcstTime'] == next2) {
          next2_TMP = parsed_json['fcstValue'];
          next2_time = timeDesc(next2)!;
        }
        if (parsed_json['fcstTime'] == next3) {
          next3_TMP = parsed_json['fcstValue'];
          next3_time = timeDesc(next3)!;
        }
        if (parsed_json['fcstTime'] == next4) {
          next4_TMP = parsed_json['fcstValue'];
          next4_time = timeDesc(next4)!;
        }
        if (parsed_json['fcstTime'] == next5) {
          next5_TMP = parsed_json['fcstValue'];
          next5_time = timeDesc(next5)!;
        }
        if (parsed_json['fcstTime'] == next6) {
          next6_TMP = parsed_json['fcstValue'];
          next6_time = timeDesc(next6)!;
        }
        if (parsed_json['fcstTime'] == next7) {
          next7_TMP = parsed_json['fcstValue'];
          next7_time = timeDesc(next7)!;
        }
        if (parsed_json['fcstTime'] == next8) {
          next8_TMP = parsed_json['fcstValue'];
          next8_time = timeDesc(next8)!;
        }
      }
      //습도
      if (parsed_json['category'] == 'REH' &&
          (parsed_json['fcstDate'] == today ||
              parsed_json['fcstDate'] == tmr)) {
        if (parsed_json['fcstTime'] == next1) {
          next1_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next2) {
          next2_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next3) {
          next3_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next4) {
          next4_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next5) {
          next5_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next6) {
          next6_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next7) {
          next7_REH = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstTime'] == next8) {
          next8_REH = parsed_json['fcstValue'];
        }
      }
      //SKY 코드값
      if (parsed_json['category'] == 'SKY') {
        //4일 sky 코드
        if (parsed_json['fcstDate'] == today ||
            parsed_json['fcstDate'] == tmr) {
          if (parsed_json['fcstTime'] == next1) {
            next1_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next2) {
            next2_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next3) {
            next3_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next4) {
            next4_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next5) {
            next5_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next6) {
            next6_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next7) {
            next7_SKY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next8) {
            next8_SKY = parsed_json['fcstValue'];
          }
        }

        //내일, 모레 sky 코드
        if (parsed_json['fcstDate'] == tmr) {
          //내일
          //6시
          if (parsed_json['fcstTime'] == '0600') {
            tmr_sky_6 = parsed_json['fcstValue'];
          }
          //18시
          if (parsed_json['fcstTime'] == '1800') {
            tmr_sky_18 = parsed_json['fcstValue'];
          }
        }
        //모레
        if (parsed_json['fcstDate'] == df_tmr) {
          //6시
          if (parsed_json['fcstTime'] == '0600') {
            df_tmr_sky_6 = parsed_json['fcstValue'];
          }
          //18시
          if (parsed_json['fcstTime'] == '1800') {
            df_tmr_sky_18 = parsed_json['fcstValue'];
          }
        }
      }

      //PTY 코드값
      if (parsed_json['category'] == 'PTY') {
        //4일 PTY 코드
        if (parsed_json['fcstDate'] == today ||
            parsed_json['fcstDate'] == tmr) {
          if (parsed_json['fcstTime'] == next1) {
            next1_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next2) {
            next2_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next3) {
            next3_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next4) {
            next4_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next5) {
            next5_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next6) {
            next6_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next7) {
            next7_PTY = parsed_json['fcstValue'];
          }
          if (parsed_json['fcstTime'] == next8) {
            next8_PTY = parsed_json['fcstValue'];
          }
        }

        //내일, 모레 pty 코드
        if (parsed_json['fcstDate'] == tmr) {
          //내일
          //6시
          if (parsed_json['fcstTime'] == '0600') {
            tmr_pty_6 = parsed_json['fcstValue'];
          }
          //18시
          if (parsed_json['fcstTime'] == '1800') {
            tmr_pty_18 = parsed_json['fcstValue'];
          }
        }
        //모레
        if (parsed_json['fcstDate'] == df_tmr) {
          //6시
          if (parsed_json['fcstTime'] == '0600') {
            df_tmr_pty_6 = parsed_json['fcstValue'];
          }
          //18시
          if (parsed_json['fcstTime'] == '1800') {
            df_tmr_pty_18 = parsed_json['fcstValue'];
          }
        }
      }

      if (parsed_json['category'] == 'TMN') {
        if (parsed_json['fcstDate'] == tmr) {
          tmr_tmn2 = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstDate'] == df_tmr) {
          df_tmr_tmn2 = parsed_json['fcstValue'];
        }
      }

      if (parsed_json['category'] == 'TMX') {
        if (parsed_json['fcstDate'] == tmr) {
          tmr_tmx2 = parsed_json['fcstValue'];
        }
        if (parsed_json['fcstDate'] == df_tmr) {
          df_tmr_tmx2 = parsed_json['fcstValue'];
        }
      }
    }
    // 모델에서 아이콘을 가져오는데 날씨가 구름이 없으면 해가 나오고(낮에) 밤에 구름이 없이 좋으면 달이 나온다. 
    next1_icon = model.getSkyIcon(next1_SKY, next1_PTY, 60, 60, next1)!;
    next2_icon = model.getSkyIcon(next2_SKY, next2_PTY, 60, 60, next2)!;
    next3_icon = model.getSkyIcon(next3_SKY, next3_PTY, 60, 60, next3)!;
    next4_icon = model.getSkyIcon(next4_SKY, next4_PTY, 60, 60, next4)!;
    next5_icon = model.getSkyIcon(next5_SKY, next5_PTY, 60, 60, next5)!;
    next6_icon = model.getSkyIcon(next6_SKY, next6_PTY, 60, 60, next6)!;
    next7_icon = model.getSkyIcon(next7_SKY, next7_PTY, 60, 60, next7)!;
    next8_icon = model.getSkyIcon(next8_SKY, next8_PTY, 60, 60, next8)!;


    tmr_icon_6 = model.getSkyIcon(tmr_sky_6, tmr_pty_6, 50, 50, '0600')!;
    tmr_icon_18 = model.getSkyIcon(tmr_sky_18, tmr_pty_18, 50, 50, '1800')!;
    df_tmr_icon_6 =
        model.getSkyIcon(df_tmr_sky_6, df_tmr_pty_6, 50, 50, '0600')!;
    df_tmr_icon_18 =
        model.getSkyIcon(df_tmr_sky_18, df_tmr_pty_18, 50, 50, '1800')!;
    tmr_tmn = double.parse('$tmr_tmn2').round();
    tmr_tmx = double.parse('$tmr_tmx2').round();
    df_tmr_tmn = double.parse('$df_tmr_tmn2').round();
    df_tmr_tmx = double.parse('$df_tmr_tmx2').round();

    //초단기 실황
    //현재 온도
    currentT1H =
        currentWeatherData['response']['body']['items']['item'][3]['obsrValue'];
    //습도
    currentREH =
        currentWeatherData['response']['body']['items']['item'][1]['obsrValue'];
    //1시간 강수량
    currentRN1 =
        currentWeatherData['response']['body']['items']['item'][2]['obsrValue'];

    //초단기 예보
    int totalCount3 = superShortWeatherData['response']['body']['totalCount']; 
    for (int i = 0; i < totalCount3; i++) {
      parsed_json =
          superShortWeatherData['response']['body']['items']['item'][i];
      //PTY 코드값
      if (parsed_json['category'] == 'PTY' &&
          parsed_json['fcstTime'] == timeHH) {
        ptyCode = parsed_json['fcstValue'];
      }
      //SKY 코드값
      if (parsed_json['category'] == 'SKY' &&
          parsed_json['fcstTime'] == timeHH) {
        skyCode = parsed_json['fcstValue'];
      }
    }
    //pty, sky, 날씨 아이콘
    current_icon = model.getSkyIcon(skyCode, ptyCode, 60, 60, timeHHString)!;
    skyIcon = model.getSkyIcon(skyCode, ptyCode, 180, 180, timeHHString)!;
    skyDesc = model.getSkyDesc(skyCode, ptyCode)!;

    //미세먼지
    air10 = airConditionData['response']['body']['items'][0]['pm10Value'];
    air25 = airConditionData['response']['body']['items'][0]['pm25Value'];

    //관측소 에러처리
    if (air10 == '-') {
      air10 = '장비점검';
      airIcon = model.getAirIcon('0')!;
      airDesc = model.getAirDesc('-1')!;
    } else {
      airIcon = model.getAirIcon(air10)!;
      airDesc = model.getAirDesc(air10)!;
    }

    if (air25 == '-') {
      air25 = '장비점검';
      airIcon25 = model.getAirIcon('0')!;
      airDesc25 = model.getAirDesc('-1')!;
    } else {
      airIcon25 = model.getAirIcon25(air25)!;
      airDesc25 = model.getAirDesc25(air25)!;
    }

    //주소
    where = addrData['documents'][0]['address']['region_1depth_name'];
    si = addrData['documents'][0]['address']['region_2depth_name'];
    addr = addrData['documents'][0]['address']['region_3depth_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //body 높이를 scaffold의 top까지 확장
      appBar: AppBar(
        backgroundColor: Colors.transparent, //appBar 투명색
        elevation: 0.0, //그림자 농도
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/setting/Orion_pin.svg',
            width: 35.0,
            height: 35.0,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/setting/Orion_menu.svg',
              width: 35.0,
              height: 35.0,
            ),
            onPressed: () {
              // Navigator.push(context,
              // MaterialPageRoute(builder: (BuildContext context) => Setting()));
            },
            iconSize: 30.0,
          )
        ],
      ),
      body: Container(
          // Stack을 사용해서 이미지를 배경 화면으로 설정하고 그 위에
          // 컨테이너를 겹치는 모습으로 보이게하기위해 stack을 사용.
          child: Stack(children: [
          Image.asset(
            'assets/cool-background.png',
            fit: BoxFit.cover, //지정된 영역을 꽉 채운다
            width: double.infinity, //가로 너비 채우기
            height: double.infinity,
        ),
        SingleChildScrollView(
          child: Container(
            // 왼쪽 오른쪽 기준으로 마진을 10정도 준다.
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, //spaceBetween은 위젯을 시작과 끝에 배치하고 그 사이에 나머지 위젯 배치
                    children: [
                      Container(
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100.0,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '$where $si',
                                style: TextStyle(
                                    fontFamily: 'tmon',
                                    fontSize: textSize(si!),
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '($addr)',
                                style: TextStyle(
                                    fontFamily: 'tmon',
                                    fontSize: 20.0,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              skyIcon,
                              skyDesc,
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '$currentT1H°C',
                                style: TextStyle(
                                    fontFamily: 'tmon',
                                    fontSize: 45.0,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '최고온도 $todayTMX°C / 최저온도 $todayTMN°C',
                                style: TextStyle(
                                    fontFamily: 'tmon',
                                    fontSize: 10.0,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
                SizedBox(
                  height: 50.0,
                ),
                //미세먼지/초미세먼지 inform box
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0),
                      height: 90.0,
                      width: 230.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/microdust_inform_background_black.jpg'),
                              fit: BoxFit.cover,
                              opacity: 200)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //미세먼지 inform
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '미세먼지',
                                  style: TextStyle(
                                      fontFamily: 'tmon',
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        airIcon,
                                        SizedBox(
                                          height: 4,
                                        ),
                                        airDesc,
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '농도',
                                          style: TextStyle(
                                              fontFamily: 'tmon',
                                              fontSize: 10.0,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '$air10 ㎍/㎥',
                                          style: TextStyle(
                                              fontFamily: 'tmon',
                                              fontSize: 10.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          //초미세먼지 inform
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '초미세먼지',
                                  style: TextStyle(
                                      fontFamily: 'tmon',
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        airIcon25,
                                        SizedBox(height: 4),
                                        airDesc25,
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '농도',
                                          style: TextStyle(
                                              fontFamily: 'tmon',
                                              fontSize: 10.0,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '$air25 ㎍/㎥',
                                          style: TextStyle(
                                              fontFamily: 'tmon',
                                              fontSize: 10.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0), // all 이므로 전체 여백을 2만큼 준다.
                      height: 230.0,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            padding:EdgeInsets.only(left:5),
                            decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/microdust_inform_background_black.jpg'),
                              fit: BoxFit.cover,
                              opacity: 200),
                            ),
                            width: double.infinity,
                            height: 16, // 가로 길이를 화면 양끝으로 꽉차게 하기.
                            child: Row(                
                              children: [
                                Text('시간대별 날씨',
                                    style: TextStyle(
                                        fontFamily: 'tmon',
                                        fontSize: 9.0,
                                        color: Colors.white)
                                ),
                                Container(
                                  width:423,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('온도',
                                        textAlign:TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'tmon',
                                          fontSize: 9.0,
                                          color: Colors.white)
                                      ),
                                      Text('  강수',
                                        textAlign:TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'tmon',
                                          fontSize: 9.0,
                                          color: Colors.white)
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),                            
                          ),                       
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            // 컨테이너의 높이를 200으로 설정
                            height: 150.0,
                            // 리스트뷰 추가
                            child: ListView(
                              // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
                              scrollDirection: Axis.horizontal,
                              // 컨테이너들을 ListView의 자식들로 추가
                              children: <Widget>[
                                  Container(
                                    width: 80,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                            current_icon,
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('지금',
                                            style: TextStyle(
                                                fontFamily: 'tmon',
                                                fontSize: 15.0,
                                                color: Colors.redAccent
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$currentREH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('$currentT1H°C',
                                            style: TextStyle(
                                                fontFamily: 'tmon',
                                                fontSize: 15.0,
                                                color: Colors.white
                                            ),
                                          ),
                                          ]
                                        ),
                                        ),
                                      ],
                                    ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next1_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next1_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next1_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next1_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                              
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next2_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next2_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next2_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next2_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),                             
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next3_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next3_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next3_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next3_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next4_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next4_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next4_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next4_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next5_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next5_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next5_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next5_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next6_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next6_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next6_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next6_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next7_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next7_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next7_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next7_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              next8_icon,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next8_time',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$next8_REH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('$next8_TMP°C',
                                                style: TextStyle(
                                                    fontFamily: 'tmon',
                                                    fontSize: 15.0,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0), // all 이므로 전체 여백을 2만큼 준다.
                      height: 230.0,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            padding:EdgeInsets.only(left:5),
                            decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/microdust_inform_background_black.jpg'),
                              fit: BoxFit.cover,
                              opacity: 200),
                            ),
                            width: double.infinity,
                            height: 16, // 가로 길이를 화면 양끝으로 꽉차게 하기.
                            child: Row(                
                              children: [
                                Text('날씨 예보',
                                    style: TextStyle(
                                        fontFamily: 'tmon',
                                        fontSize: 9.0,
                                        color: Colors.white)
                                    ),
                                  ],
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [td_icon_6, td_icon_18],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '오늘',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 15.0,
                                                  color: Colors.redAccent),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/weather_icon/humidity.svg',
                                                    width: 30.0,
                                                    height: 30.0,
                                                  ),
                                                  Text('$currentREH%',
                                                    style: TextStyle(
                                                        fontFamily: 'tmon',
                                                        fontSize: 14.0,
                                                        color: Colors.white
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$todayTMN°C / $todayTMX°C',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 13.0,
                                                  color: Colors.white),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                tmr_icon_6,
                                                tmr_icon_18
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              daysFormat.format(DateTime.now()
                                                  .add(Duration(days: 1))),
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$next1_REH%',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$tmr_tmn°C / $tmr_tmx°C',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 13.0,
                                                  color: Colors.white),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                df_tmr_icon_6,
                                                df_tmr_icon_18
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              daysFormat.format(DateTime.now()
                                                  .add(Duration(days: 2))),
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$next3_REH%',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$df_tmr_tmn°C / $df_tmr_tmx°C',
                                              style: TextStyle(
                                                  fontFamily: 'tmon',
                                                  fontSize: 13.0,
                                                  color: Colors.white),
                                            ),
                                          ]
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}

double textSize(String addr) {
  int len = addr.length;
  if (len > 7) {
    return 28.0;
  } else
    return 30.0;
}
