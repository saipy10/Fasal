import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  static const String apiKeyForecast =
      "b48102e5e36045aabcd63316242402"; // Replace with your WeatherAPI key
  static const String baseUrl = "http://api.weatherapi.com/v1/forecast.json";
  static const String apiKey =
      "7e2814fbb5fa372376bd1dd8fd4f907e"; // 🔹 Replace with your OpenWeather API Key
  static const String baseWeatherUrl =
      "https://api.openweathermap.org/data/2.5/weather";
  static const String baseForecastUrl =
      "https://api.openweathermap.org/data/2.5/forecast/daily";

  // ✅ Fetch Current Weather by Coordinates
  static Future<WeatherModel> getWeatherByCoords(
    double latitude,
    double longitude,
  ) async {
    final url =
        "$baseWeatherUrl?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  // ✅ Fetch Current Weather by City Name
  static Future<WeatherModel> getWeatherByCity(String city) async {
    final url = "$baseWeatherUrl?q=$city&units=metric&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Failed to load weather data for $city");
    }
  }

  // ✅ Fetch Weekly Weather Forecast by Coordinates
  static Future<List<ForecastModel>> getWeeklyForecast(String location) async {
    final url =
        "$baseUrl?key=$apiKeyForecast&q=$location&days=7&aqi=no&alerts=no";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<ForecastModel> forecastList =
          (data['forecast']['forecastday'] as List).map((item) {
            return ForecastModel(
              day: item['date'],
              temperature: item['day']['avgtemp_c'].toDouble(),
              condition: item['day']['condition']['text'],
            );
          }).toList();

      return forecastList;
    } else {
      throw Exception("Failed to load weekly forecast");
    }
  }
}
