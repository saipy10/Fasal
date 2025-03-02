import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/forecast_model.dart';

class WeatherForecastPage extends StatefulWidget {
  final String location; // Accept city name

  WeatherForecastPage({required this.location});

  @override
  _WeatherForecastPageState createState() => _WeatherForecastPageState();
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  List<ForecastModel>? weeklyForecast;

  @override
  void initState() {
    super.initState();
    _fetchWeeklyForecast();
  }

  Future<void> _fetchWeeklyForecast() async {
    try {
      var forecastData = await WeatherService.getWeeklyForecast(
        widget.location,
      );
      setState(() {
        weeklyForecast = forecastData;
      });
    } catch (e) {
      print("Error fetching forecast: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forecast")),
      body:
          weeklyForecast == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: weeklyForecast!.length,
                itemBuilder: (context, index) {
                  final forecast = weeklyForecast![index];
                  return ListTile(
                    leading: Text(
                      forecast.weatherEmoji,
                      style: TextStyle(fontSize: 32), // Make emoji large
                    ),
                    title: Text(forecast.day),
                    subtitle: Text(
                      "${forecast.temperature}°C - ${forecast.condition}",
                    ),
                  );
                },
              ),
    );
  }
}
