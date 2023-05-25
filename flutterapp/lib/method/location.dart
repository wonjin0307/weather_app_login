import 'package:geolocator/geolocator.dart';
import 'dart:math';

// 기상청은 위도 경도가 아닌 x,y좌표를 기준으로 하기때문에 위도 경도를 x,y좌표로 변경하는 클래스와 메서드 생성 changeLaluMap()
class Weather_map_xy {
  int x;
  int y;
  Weather_map_xy(this.x, this.y);
}

class lamc_parameter {
  double? Re; /* 사용할 지구반경 [ km ]      */
  double? grid; /* 격자간격        [ km ]      */
  double? slat1; /* 표준위도        [degree]    */
  double? slat2; /* 표준위도        [degree]    */
  double? olon; /* 기준점의 경도   [degree]    */
  double? olat; /* 기준점의 위도   [degree]    */
  double? xo; /* 기준점의 X 좌표  [격자거리]  */
  double? yo; /* 기준점의 Y 좌표  [격자거리]  */
  int? first; /* 시작여부 (0 = 시작)         */
}

Weather_map_xy changelaluMap(double longitude, double latitude) {
  int NX = 149; /* X 축 격자점 수 */
  int NY = 253; /* Y 축 격자점 수 */
  double? PI, DEGRAD, RADDEG;
  double? re, olon, olat, sn, sf, ro;
  double? slat1, slat2, alon, alat, xn, yn, ra, theta;
  lamc_parameter map = lamc_parameter();
  map.Re = 6371.00877; // 지도반경
  map.grid = 5.0; // 격자간격 (km)
  map.slat1 = 30.0; // 표준위도 1
  map.slat2 = 60.0; // 표준위도 2
  map.olon = 126.0; // 기준점 경도
  map.olat = 38.0; // 기준점 위도
  map.xo = 210 / map.grid!; // 기준점 X 좌표
  map.yo = 675 / map.grid!; // 기준점 Y 좌표
  map.first = 0;
  if ((map).first == 0) {
    // PI = asin(1.0) * 2.0;
    PI = 3.1415926535897931;
    DEGRAD = PI / 180.0;
    RADDEG = 180.0 / PI;
    re = map.Re! / map.grid!;
    slat1 = map.slat1! * DEGRAD;
    slat2 = map.slat2! * DEGRAD;
    olon = map.olon! * DEGRAD;
    olat = map.olat! * DEGRAD;
    sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5);
    sn = log(cos(slat1) / cos(slat2)) / log(sn);
    sf = tan(PI * 0.25 + slat1 * 0.5);
    sf = pow(sf, sn) * cos(slat1) / sn;
    ro = tan(PI * 0.25 + olat * 0.5);
    ro = re * sf / pow(ro, sn);
    map.first = 1;
  }
  ra = tan(PI! * 0.25 + latitude * DEGRAD! * 0.5);
  ra = re! * sf! / pow(ra, sn!);
  theta = longitude * DEGRAD - olon!;
  if (theta > PI) theta -= 2.0 * PI;
  if (theta < -PI) theta += 2.0 * PI;
  theta *= sn;

  double x = (ra * sin(theta)) + map.xo!;
  double y = (ro! - ra * cos(theta)) + map.yo!;
  x = x + 1.5;
  y = y + 1.5;
  return Weather_map_xy(x.toInt(), y.toInt());
}

// 위치 좌표를 구하는 Location 클래스
class Location{
  int? currentX;
  int? currentY;
  late double latitude;
  late double longitude;


  // async-await: 비동기식 처리를 위해 await를 사용하여 해당 함수의 스코프를 알려주는 async를 무조껀 사용해야한다.
  // async함수는 반드시 Future를 반환해야한다. Future:지금은 없지만 후에 요청한 데이터 혹은 에러가 나올 그릇?
  Future<void>getCurrentLocation() async{
    try{
      // LocationPermission :서비스를 사용하는 앱에서 위치 정보 액세스 권한을 요청
      // 위치 서비스가 활성화되었는지 여부를 확인하기 위해서 Geolocator에서 checkPermission()을 호출한다.
      // 만약 위치 서비스가 거부되었다면
      // 위치 서비스에대한 권한을 재요청한다.
      // 현재 위치를 쿼리하기위해 getCurrentPosition 메서드를 호출 / desiredAccuracy: 앱이 수신하려는 위치 데이터의 정확성
      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
        );
      latitude = position.latitude;
      longitude = position.longitude;
      // 위도와 경도를 changelaluMap(longitude, latitude)에 넣어서 x,y좌표로 변환
      Weather_map_xy weathermapxy = changelaluMap(position.longitude, position.latitude);
      currentX = weathermapxy.x;
      currentY = weathermapxy.y;
    }catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}