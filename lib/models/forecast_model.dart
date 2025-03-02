class ForecastModel {
  final String day;
  final double temperature;
  final String condition;

  ForecastModel({
    required this.day,
    required this.temperature,
    required this.condition,
  });

  // Convert condition to emoji
  String get weatherEmoji {
    if (condition.toLowerCase().contains("rain")) return "🌧️";
    if (condition.toLowerCase().contains("cloud")) return "☁️";
    if (condition.toLowerCase().contains("sun") ||
        condition.toLowerCase().contains("clear"))
      return "☀️";
    if (condition.toLowerCase().contains("snow")) return "❄️";
    if (condition.toLowerCase().contains("storm")) return "⛈️";
    return "🌡️"; // Default icon
  }
}
