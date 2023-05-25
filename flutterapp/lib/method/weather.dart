import '../method/location.dart';
import 'package:flutterapp/method/networking.dart';

// 외부 날씨 APIKEY
// 날씨 오픈 API를 가져오기위한 URL부분을 openWeatherMapURL에 할당한다. API를 사용할때마다 이부분을 반복적으로 사용해야되니깐
// 변수지정을 해줬다.
const apiKey = 'b06c81556611a45d7d75d3c4a62b9027';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
// const kakaoApiKey = '9cc0f83bb5119f7f7a401f465153f498';

// 해당 클래스 안에 도시에 따른 날씨정보를 넘겨주는 메서드와 사용자 위치에 따른 날씨정보를 넘겨주는 메서드를 생성하였고,
// 해당 날씨에 대한 값에 따라 날씨아이콘으로 넘겨주는 메서드 존재.
class WeatherModel{
  // getCityWeather메서드: 해당 메서드에 도시이름을 넣으면 날씨 정보를 넘겨주는 메서드
  // url 형식에서 변수값으로 들어가는 부분과 해당 메서드를 호출할때마다 선언되는 변수값들을 $형식으로 선언하여 URL로 할당.
  // 해당 URL를 날씨데이터를 구하는 메서드의 인자값으로넣어서 해당 데이터를 network에 할당.
  // getData를 통하여 해당 데이터의 응답 데이터 알짜배기(body)를 가져오고 해당 데이터를 리턴한다.
  Future<dynamic>getCityWeather(String cityName) async{
    var url = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric';
    Network network = Network(url);
    var weatherData = await network.getData();
    return weatherData;
  }
  // getLocationWeather메서드: 사용자 위치에 따른 날씨 정보를 넘겨주는 메서드
  // 위의 getCityWeather 메서드의 로직과 동일하다.
  Future<dynamic>getLocationWeather() async{
    Location location = Location();
    await location.getCurrentLocation();
    Network network = Network('$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await network.getData();
    return weatherData;
  }









  
  // getWeatherIcon 메서드: 컨디션 값을 정수값으로 반환하여 해당 값에 따라 날씨아이콘을 반환해주는 메서드
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
