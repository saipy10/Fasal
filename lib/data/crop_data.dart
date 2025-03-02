// crop_data.dart
class CropData {
  static final Map<String, List<Map<String, dynamic>>> _historicalPrices = {
    "wheat": [
      {"date": "2024-03", "price": 2400.0},
      {"date": "2024-04", "price": 2450.0},
      {"date": "2024-05", "price": 2500.0},
      {"date": "2024-06", "price": 2480.0},
      {"date": "2024-07", "price": 2420.0},
      {"date": "2024-08", "price": 2380.0},
      {"date": "2024-09", "price": 2350.0},
      {"date": "2024-10", "price": 2400.0},
      {"date": "2024-11", "price": 2450.0},
      {"date": "2024-12", "price": 2550.0},
      {"date": "2025-01", "price": 2600.0},
      {"date": "2025-02", "price": 2580.0},
    ],
    "rice": [
      {"date": "2024-03", "price": 3000.0},
      {"date": "2024-04", "price": 3050.0},
      {"date": "2024-05", "price": 3100.0},
      {"date": "2024-06", "price": 3080.0},
      {"date": "2024-07", "price": 3150.0},
      {"date": "2024-08", "price": 3200.0},
      {"date": "2024-09", "price": 3180.0},
      {"date": "2024-10", "price": 3250.0},
      {"date": "2024-11", "price": 3300.0},
      {"date": "2024-12", "price": 3350.0},
      {"date": "2025-01", "price": 3400.0},
      {"date": "2025-02", "price": 3380.0},
    ],
    "maize": [
      {"date": "2024-03", "price": 1900.0},
      {"date": "2024-04", "price": 1950.0},
      {"date": "2024-05", "price": 2000.0},
      {"date": "2024-06", "price": 1980.0},
      {"date": "2024-07", "price": 1920.0},
      {"date": "2024-08", "price": 1880.0},
      {"date": "2024-09", "price": 1850.0},
      {"date": "2024-10", "price": 1900.0},
      {"date": "2024-11", "price": 1950.0},
      {"date": "2024-12", "price": 2000.0},
      {"date": "2025-01", "price": 2050.0},
      {"date": "2025-02", "price": 2030.0},
    ],
    "sugarcane": [
      {"date": "2024-03", "price": 3100.0},
      {"date": "2024-04", "price": 3150.0},
      {"date": "2024-05", "price": 3200.0},
      {"date": "2024-06", "price": 3180.0},
      {"date": "2024-07", "price": 3220.0},
      {"date": "2024-08", "price": 3250.0},
      {"date": "2024-09", "price": 3280.0},
      {"date": "2024-10", "price": 3300.0},
      {"date": "2024-11", "price": 3350.0},
      {"date": "2024-12", "price": 3400.0},
      {"date": "2025-01", "price": 3450.0},
      {"date": "2025-02", "price": 3430.0},
    ],
  };

  static Map<String, List<Map<String, dynamic>>> getHistoricalPrices(String state) {
    // Since we're using static data for Maharashtra, ignore the state parameter
    return _historicalPrices;
  }
}