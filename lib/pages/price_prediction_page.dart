import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PricePredictionPage extends StatefulWidget {
  const PricePredictionPage({super.key});

  @override
  _PricePredictionPageState createState() => _PricePredictionPageState();
}

class _PricePredictionPageState extends State<PricePredictionPage> {
  final TextEditingController _rainfallController = TextEditingController();
  String? selectedState;
  String? selectedCommodity;
  double? predictedPrice;
  bool isLoading = false;

  final Map<String, List<String>> stateCommodityMap = {
    "Punjab": ["Wheat", "Rice", "Maize", "Paddy"],
    "Haryana": ["Wheat", "Rice", "Bajra", "Mustard"],
    "Karnataka": ["Ragi", "Maize", "Tur (Arhar)", "Jowar"],
    "Andhra Pradesh": ["Paddy", "Groundnut", "Tur (Arhar)", "Maize"],
    "Telangana": ["Paddy", "Cotton", "Maize", "Soybean"],
    "Maharashtra": ["Sugarcane", "Cotton", "Soybean", "Jowar"],
    "Madhya Pradesh": ["Wheat", "Soybean", "Mustard", "Urad"],
    "Tamil Nadu": ["Paddy", "Sugarcane", "Groundnut", "Sunflower"],
    "Gujarat": ["Cotton", "Groundnut", "Tur (Arhar)", "Mustard"],
    "Uttar Pradesh": ["Wheat", "Sugarcane", "Paddy", "Mustard"],
    "Rajasthan": ["Bajra", "Moong", "Mustard", "Wheat"],
  };

  final List<String> states = [
    "Punjab",
    "Haryana",
    "Karnataka",
    "Andhra Pradesh",
    "Telangana",
    "Maharashtra",
    "Madhya Pradesh",
    "Tamil Nadu",
    "Gujarat",
    "Uttar Pradesh",
    "Rajasthan",
  ];

  final Map<String, double> stateRainfallMap = {
    "Punjab": 650,
    "Haryana": 600,
    "Karnataka": 900,
    "Andhra Pradesh": 1200,
    "Telangana": 1100,
    "Maharashtra": 850,
    "Madhya Pradesh": 700,
    "Tamil Nadu": 1300,
    "Gujarat": 800,
    "Uttar Pradesh": 1000,
    "Rajasthan": 400,
  };

  List<String> getCommoditiesForState(String state) {
    return stateCommodityMap[state] ?? [];
  }

  Future<void> predictPrice() async {
    if (selectedState == null ||
        selectedCommodity == null ||
        _rainfallController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      predictedPrice = null;
    });

    try {
      final response = await http.post(
        Uri.parse("https://fasal-backend.onrender.com/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "State": selectedState,
          "Commodity": selectedCommodity,
          "Annual Rainfall": double.parse(_rainfallController.text),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          predictedPrice =
              jsonDecode(response.body)["Predicted Crop Price (₹)"].toDouble();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonDecode(response.body)["error"] ?? "Unknown error",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to connect to server: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (predictedPrice == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "6-Month Forecast",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                buildDropdown("Select State", states, selectedState, (value) {
                  setState(() {
                    selectedState = value;
                    selectedCommodity = null;
                    if (value != null) {
                      _rainfallController.text =
                          stateRainfallMap[value]?.toString() ?? "";
                    } else {
                      _rainfallController.clear();
                    }
                  });
                }),

                const SizedBox(height: 15),
                buildDropdown(
                  "Select Commodity",
                  selectedState != null
                      ? getCommoditiesForState(selectedState!)
                      : [],
                  selectedCommodity,
                  (value) => setState(() => selectedCommodity = value),
                ),
                const SizedBox(height: 15),
                buildTextField("Annual Rainfall (mm)", _rainfallController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : predictPrice,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Get Prediction"),
                ),
                const SizedBox(height: 20),
                if (predictedPrice != null) buildPriceDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPriceDisplay() {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Predicted Crop Price",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "₹${predictedPrice!.toStringAsFixed(2)} / q",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              elevation: 1,
              dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              hint: Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              items:
                  items
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: onChanged,
              menuMaxHeight: 200,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
