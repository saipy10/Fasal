class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final String iconUrl;
  final double latitude;  // ✅ Added latitude
  final double longitude; // ✅ Added longitude
  final double humidity;  // ✅ Added humidity
  final double windSpeed; // ✅ Added wind speed

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.latitude,  // ✅ Initialize latitude
    required this.longitude, // ✅ Initialize longitude
    required this.humidity,  // ✅ Initialize humidity
    required this.windSpeed, // ✅ Initialize wind speed
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['description'],
      iconUrl: "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      latitude: (json['coord']['lat'] as num).toDouble(),  // ✅ Extract from API
      longitude: (json['coord']['lon'] as num).toDouble(), // ✅ Extract from API
      humidity: (json['main']['humidity'] as num).toDouble(), // ✅ Extract from API
      windSpeed: (json['wind']['speed'] as num).toDouble(),  // ✅ Extract from API
    );
  }
}
