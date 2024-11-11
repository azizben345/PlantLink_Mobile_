import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<SensorData>> fetchSensorData(String sensorType) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/sensor-data/$sensorType/'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => SensorData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load sensor data');
  }
}

class SensorData {
  final String sensorType;
  final double value;
  final String timestamp;

  SensorData({required this.sensorType, required this.value, required this.timestamp});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      sensorType: json['sensor_type'],
      value: json['value'],
      timestamp: json['timestamp'],
    );
  }
}

