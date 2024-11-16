import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Data lists for each sensor type
  List<double> phData = [];
  List<double> rainfallData = [];
  List<double> humidityData = [];
  List<double> tempData = [];
  List<double> nitrogenData = [];
  List<double> phosphorousData = [];
  List<double> potassiumData = [];

  // Timestamps for each sensor type
  List<String> rainfallTimestamps = [];
  List<String> humidTempTimestamps = [];
  List<String> npkTimestamps = [];

  bool isLoading = true;

  // Default chart type for each chart section
  Map<String, String> selectedChartTypes = {
    "pH Level Chart": "Spline Chart",
    "Rainfall Chart": "Spline Chart",
    "Humidity Chart": "Spline Chart",
    "Temperature Chart": "Spline Chart",
    "Nitrogen Chart": "Spline Chart",
    "Phosphorous Chart": "Spline Chart",
    "Potassium Chart": "Spline Chart",
  };

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/mychannel/672484a397fae572346fda56/get_dashboard_data/')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        // Parse data for each sensor type and timestamp
        phData = List<double>.from(data['ph_values']?.map((v) => double.parse(v)) ?? []);
        rainfallData = List<double>.from(data['rainfall_values']?.map((v) => double.parse(v)) ?? []);
        humidityData = List<double>.from(data['humid_values']?.map((v) => double.parse(v)) ?? []);
        tempData = List<double>.from(data['temp_values']?.map((v) => double.parse(v)) ?? []);
        nitrogenData = List<double>.from(data['nitrogen_values']?.map((v) => double.parse(v)) ?? []);
        phosphorousData = List<double>.from(data['phosphorous_values']?.map((v) => double.parse(v)) ?? []);
        potassiumData = List<double>.from(data['potassium_values']?.map((v) => double.parse(v)) ?? []);

        rainfallTimestamps = List<String>.from(data['timestamps'] ?? []);
        humidTempTimestamps = List<String>.from(data['timestamps_humid_temp'] ?? []);
        npkTimestamps = List<String>.from(data['timestamps_NPK'] ?? []);

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load sensor data');
    }
  }

  // Generate FlSpots for each sensor type
  List<FlSpot> _generateSpots(List<double> data) {
    return List.generate(data.length, (index) {
      return FlSpot(index.toDouble(), data[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildChartSection("pH Level Chart", _generateSpots(phData), []),
                  const SizedBox(height: 20),
                  _buildChartSection("Rainfall Chart", _generateSpots(rainfallData), rainfallTimestamps),
                  const SizedBox(height: 20),
                  _buildChartSection("Humidity Chart", _generateSpots(humidityData), humidTempTimestamps),
                  const SizedBox(height: 20),
                  _buildChartSection("Temperature Chart", _generateSpots(tempData), humidTempTimestamps),
                  const SizedBox(height: 20),
                  _buildChartSection("Nitrogen Chart", _generateSpots(nitrogenData), npkTimestamps),
                  const SizedBox(height: 20),
                  _buildChartSection("Phosphorous Chart", _generateSpots(phosphorousData), npkTimestamps),
                  const SizedBox(height: 20),
                  _buildChartSection("Potassium Chart", _generateSpots(potassiumData), npkTimestamps),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      GreenButtonWithIcon(
                        label: 'Share Channel',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      GreenButtonWithIcon(
                        label: 'Configure Sensor',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      GreenButtonWithIcon(
                        label: 'Connect Sensor',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // Function to build a chart section with a dropdown to select chart type
  Widget _buildChartSection(String title, List<FlSpot> spots, List<String> timestamps) {
    if (spots.isEmpty) return const SizedBox(); // Handle case with no data

    double minXValue = spots.first.x;
    double maxXValue = spots.last.x;

    // Determine min and max y values for better y-axis range
    double minYValue = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxYValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Get screen width for responsive chart sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double chartPadding = 16.0; // Add padding for y-axis labels to display properly

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            DropdownButton<String>(
              value: selectedChartTypes[title],
              items: ["Spline Chart", "Line Chart", "Bar Chart"]
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedChartTypes[title] = value!;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              minX: minXValue,
              maxX: maxXValue,
              minY: minYValue,
              maxY: maxYValue,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < timestamps.length) {
                        return Text(
                          timestamps[index],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              lineBarsData: [
                _getChartData(spots, selectedChartTypes[title].toString()),
              ],
              borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 10, // Spacing for horizontal grid lines
                ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _getChartData(List<FlSpot> spots, String chartType) {
    switch (chartType) {
      case "Line Chart":
        return LineChartBarData(
          spots: spots,
          isCurved: false, // Line chart is not curved
          color: Colors.blue,
          belowBarData: BarAreaData(show: false),
        );
      case "Bar Chart":
        return LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 8,
          color: Colors.green,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        );
      default: // "Spline Chart"
        return LineChartBarData(
          spots: spots,
          isCurved: true, // Spline chart is curved
          color: const Color.fromARGB(255, 0, 244, 45),
          belowBarData: BarAreaData(show: false),
        );
    }
  }
  List<BarChartGroupData> _getBarChartData(List<FlSpot> spots) {
    return spots.map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y,
            color: Colors.green,
            width: 8,
          ),
        ],
      );
    }).toList();
  }

}

class GreenButtonWithIcon extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GreenButtonWithIcon({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(FontAwesomeIcons.fileCirclePlus, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Set the background color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      onPressed: onPressed,
    );
  }
}