import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  final String baseUrl = 'http://127.0.0.1:8000'; 

  // Fetch sensors for a specific channel
  Future<Map<String, dynamic>> fetchSensors(String channelId) async {
    final url = Uri.parse('$baseUrl/mychannel/$channelId/manage_sensor');

    try {
      final response = await http.get(url); 

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load sensors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sensors: $e');
    }
  }

  Future<void> editSensor({
  required String channelId,
  required String sensorType,
  required String sensorId,
  required String newSensorName,
  required String apiKey,
}) async {
  final url = Uri.parse('$baseUrl/mychannel/$channelId/edit_sensor/$sensorType/$sensorId/');
  final requestBody = json.encode({
    'sensorName': newSensorName,
    'sensorType': sensorType,
    'ApiKey': apiKey,
  });

  print('Edit Sensor Request URL: $url');
  print('Edit Sensor Request Body: $requestBody');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: requestBody,
  );

  print('Edit Sensor Response Status: ${response.statusCode}');
  print('Edit Sensor Response Body: ${response.body}');

  if (response.statusCode != 200) { // Adjust based on backend's success status code
    throw Exception('Failed to edit sensor');
  }
}


  // Delete a sensor
  Future<void> deleteSensor({
    required String channelId,
    required String sensorType,
  }) async {
    final url = Uri.parse('$baseUrl/mychannel/$channelId/delete_sensor/$sensorType/');
    final response = await http.delete(url);

    if (response.statusCode != 302) {
      throw Exception('Failed to delete sensor');
    }
  }

 // Unset a sensor
  Future<void> unsetSensor(String channelId) async {
    final url = Uri.parse('$baseUrl/mychannel/$channelId/unset_sensor');

    try {
      final response = await http.post(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to unset sensor. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error unsetting sensor: $e');
    }
  }
}

