import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CropDetailPage extends StatefulWidget {
  final Map<String, dynamic> crop;

  const CropDetailPage({required this.crop, super.key});

  @override
  _CropDetailPageState createState() => _CropDetailPageState();
}

class _CropDetailPageState extends State<CropDetailPage> {
  final Map<String, IconData> cropIcons = {
    "wheat": Icons.grass,
    "rice": Icons.rice_bowl,
    "maize": Icons.agriculture,
    "sugarcane": Icons.eco,
  };

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMM yy').format(parsedDate);
    } catch (e) {
      return date.length >= 4 ? date.substring(2, 7) : date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String cropName = widget.crop['name'];
    final List<Map<String, dynamic>> history = widget.crop['history'] ?? [];

    final double avgPrice =
        history.isNotEmpty
            ? history.map((e) => e['price'] as double).reduce((a, b) => a + b) /
                history.length
            : 0;
    final double minPrice =
        history.isNotEmpty
            ? history
                .map((e) => e['price'] as double)
                .reduce((a, b) => a < b ? a : b)
            : 0;
    final double maxPrice =
        history.isNotEmpty
            ? history
                .map((e) => e['price'] as double)
                .reduce((a, b) => a > b ? a : b)
            : 0;
    final double priceChange =
        history.length >= 2
            ? ((history.last['price'] - history.first['price']) /
                    history.first['price']) *
                100
            : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("${cropName.capitalize()} Details"),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Crop Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cropIcons[cropName],
                        size: 48,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          cropName.capitalize(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Price Statistics
                const Text(
                  "Price Statistics",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatRow(
                          "Average Price",
                          "₹${avgPrice.toStringAsFixed(0)}",
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          "Minimum Price",
                          "₹${minPrice.toStringAsFixed(0)}",
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          "Maximum Price",
                          "₹${maxPrice.toStringAsFixed(0)}",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Price Trend Chart
                const Text(
                  "Price Trend",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '₹${value.toInt()}',
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: _calculateInterval(history.length),
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < history.length) {
                                    return Transform.rotate(
                                      angle: -45 * 3.14159 / 180,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          _formatDate(history[index]['date']),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: history.length.toDouble() - 1,
                          minY: minPrice * 0.9,
                          maxY: maxPrice * 1.1,
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                                  history
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => FlSpot(
                                          e.key.toDouble(),
                                          e.value['price'],
                                        ),
                                      )
                                      .toList(),
                              isCurved: true,
                              color: Colors.green.shade700,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Additional Details
                const Text(
                  "Market Insights",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatRow(
                          "Price Change",
                          "${priceChange.toStringAsFixed(1)}% (${priceChange >= 0 ? '▲' : '▼'})",
                          valueColor:
                              priceChange >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow("Data Points", history.length.toString()),
                        const SizedBox(height: 8),
                        _buildStatRow(
                          "Last Updated",
                          history.isNotEmpty
                              ? _formatDate(history.last['date'])
                              : "N/A",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateInterval(int dataLength) {
    if (dataLength <= 5) return 1;
    if (dataLength <= 10) return 2;
    if (dataLength <= 20) return 4;
    return (dataLength / 5).floor().toDouble();
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
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
