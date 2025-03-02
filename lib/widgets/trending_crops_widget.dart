import 'package:fasal/data/crop_data.dart';
import 'package:fasal/pages/crop_detail_page.dart';
import 'package:flutter/material.dart';

class TrendingCropsWidget extends StatefulWidget {
  @override
  _TrendingCropsWidgetState createState() => _TrendingCropsWidgetState();
}

class _TrendingCropsWidgetState extends State<TrendingCropsWidget> {
  Map<String, List<Map<String, dynamic>>> historicalPrices = {};
  bool isLoading = true;
  String userState = "Maharashtra"; // Fixed to Maharashtra

  final List<String> crops = ["wheat", "rice", "maize", "sugarcane"];
  final Map<String, IconData> cropIcons = {
    "wheat": Icons.grain,
    "rice": Icons.rice_bowl,
    "maize": Icons.local_florist,
    "sugarcane": Icons.spa,
    "cotton": Icons.cloud,
    "soybean": Icons.eco,
    "potato": Icons.circle,
    "tomato": Icons.local_dining,
    "millet": Icons.grass,
    "barley": Icons.water_drop,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = CropData.getHistoricalPrices(userState);
    if (mounted) {
      setState(() {
        historicalPrices = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trending Crops in ${StringExtension(userState).capitalize()}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        SizedBox(height: 10),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                final latestPrice =
                    historicalPrices[crop]?.isNotEmpty == true
                        ? historicalPrices[crop]!.last['price'].toStringAsFixed(
                          0,
                        )
                        : "N/A";

                return AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CropDetailPage(
                                crop: {
                                  "name": crop,
                                  "history": historicalPrices[crop],
                                },
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.grey[800] // Darker in dark mode
                                : Colors
                                    .green
                                    .shade100, // Lighter in light mode
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDarkMode ? 0.2 : 0.1,
                            ),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cropIcons[crop],
                                size: 24,
                                color: Colors.green.shade800,
                              ),
                              SizedBox(width: 8),
                              Text(
                                StringExtension(crop).capitalize(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Latest Price",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[900],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "₹$latestPrice",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
