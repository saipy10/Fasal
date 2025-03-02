import 'package:fasal/models/forecast_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'location_input_dialog.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherModel? weather;
  String location = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Fetch weather using GPS
  Future<void> _fetchWeather() async {
    Position position = await _getLocation();
    var weatherData = await WeatherService.getWeatherByCoords(
      position.latitude,
      position.longitude,
    );
    setState(() {
      weather = weatherData;
      location = weatherData.city;
    });
  }

  // Fetch weather using manual city input
  Future<void> _fetchWeatherByCity(String city) async {
    var weatherData = await WeatherService.getWeatherByCity(city);
    setState(() {
      weather = weatherData;
      location = weatherData.city;
    });
  }

  // Get user location
  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Show location input dialog
  Future<void> _showLocationDialog() async {
    String? city = await showDialog(
      context: context,
      builder: (context) => LocationInputDialog(),
    );
    if (city != null && city.isNotEmpty) {
      _fetchWeatherByCity(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showForecastDialog(
      BuildContext context,
      List<ForecastModel> forecast,
    ) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Forecast",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: forecast.length,
                itemBuilder: (context, index) {
                  final dayForecast = forecast[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Text(
                          dayForecast.weatherEmoji,
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          dayForecast.day,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${dayForecast.temperature}°C - ${dayForecast.condition}",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading and Calendar Icon outside the weather box
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weather Updates",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.blue),
                onPressed: () async {
                  List<ForecastModel> forecast =
                      await WeatherService.getWeeklyForecast(location);
                  _showForecastDialog(context, forecast);
                },
                tooltip: "Forecast",
              ),
            ],
          ),
        ),

        // Weather Box
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  if (weather != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Side: City Name + GPS Icon + Temperature Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _showLocationDialog,
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                IconButton(
                                  icon: Icon(
                                    Icons.gps_fixed,
                                    color: Colors.blue,
                                  ),
                                  onPressed: _fetchWeather,
                                  tooltip: "Use GPS",
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${weather!.temperature}°C - ${weather!.condition}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        // Right Side: Weather Icon
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            weather!.iconUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    )
                  else
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
