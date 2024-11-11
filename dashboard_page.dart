import 'package:flutter/material.dart';
import 'package:plantlink_mobile_/sensor_data.dart';
import 'package:fl_chart/fl_chart.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantLink Dashboard',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard: test'),
          /*actions: [
            TextButton(onPressed: () {}, child: const Text('Home')),
            TextButton(onPressed: () {}, child: const Text('My Channel')),
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {},
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Logout', child: Text('Logout')),
              ],
            ),
          ],*/
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description: test', style: TextStyle(fontSize: 16)),
                const Text('Location: test', style: TextStyle(fontSize: 16)),
                SwitchListTile(
                  title: const Text('Allow receive sensor data'),
                  value: true,
                  onChanged: (value) {},
                ),
                const Row(
                  children: [
                    Expanded(child: SensorChart(title: 'PH Value', sensorType: 'ph_sensor',)),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: SensorChart(title: 'Rainfall Value', sensorType: 'rainfall_sensor',)),
                  ]
                ),
                const SizedBox(height: 20),
                //Row(
                  //children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.note_add,  // Use an icon that represents "page with +"; this icon may vary
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Share Channel',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,  // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),  // Slightly curved corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // Padding inside the button
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.note_add,  // Use an icon that represents "page with +"; this icon may vary
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Configure Sensor',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,  // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),  // Slightly curved corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // Padding inside the button
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.note_add,  // Use an icon that represents "page with +"; this icon may vary
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Connect Sensor',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,  // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),  // Slightly curved corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // Padding inside the button
                          ),
                        )
                      ],
                    ),
                  //],
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//maybe put this in sensor_data.dart
class SensorChart extends StatelessWidget {
  final String title;
  final String sensorType;

  const SensorChart({required this.title, required this.sensorType});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 200,
          //child: LineChart(lineChartData(placeholderLineChartData())), // Example chart; adjust as needed
          child: LineChart(placeholderLineChartData()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: 'Select Chart Type',
              items: <String>['Select Chart Type', 'Line Chart', 'Bar Chart']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,  
                  color: Colors.white,
                ),
                label: const Text(
                  'Share Chart',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,  // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),  // Slightly curved corners
                  ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),  // Padding inside the button
              ),
            )
          ],
        ),
      ],
    );
  }

  LineChartData lineChartData(List<SensorData> sensorDataList) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: sensorDataList.map((data) {
            final timestamp = DateTime.parse(data.timestamp);
            return FlSpot(timestamp.millisecondsSinceEpoch.toDouble(), data.value);
          }).toList(),
          isCurved: true,
          colors: [Colors.teal],
        ),
      ],
    );
  }
}

// Placeholder LineChartData for a loading state
LineChartData placeholderLineChartData() {
  return LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
        ],
        isCurved: true,
        colors: [Colors.grey],
        barWidth: 2,
        dotData: FlDotData(show: false),
      ),
    ],
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    gridData: FlGridData(show: false),
  );
}