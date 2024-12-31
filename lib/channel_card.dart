import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'channel_page.dart';

class ChannelCard extends StatelessWidget {
  final Channel channel; // Use Channel object instead of individual parameters
  final VoidCallback onViewChannel;
  final VoidCallback onEditChannel;
  final VoidCallback onDeleteChannel;

  const ChannelCard({
    Key? key,
    required this.channel,  // Now passing the entire channel object
    required this.onViewChannel,
    required this.onEditChannel,
    required this.onDeleteChannel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                channel.name,  // Use the 'name' from the Channel object
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(channel.description),  // Use the 'description' from the Channel object
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                channel.dateCreated,  // Use 'dateCreated' field if present
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                channel.dateModified,  // Use 'dateModified' field if present
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                channel.sensorCount.toString(),  // Use the 'sensorCount' from the Channel object
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  onPressed: onViewChannel,
                  tooltip: 'View Channel',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEditChannel,
                  tooltip: 'Edit Channel',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDeleteChannel,
                  tooltip: 'Delete Channel',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Channel {
  final String id;
  final String name;
  final String description;
  final int sensorCount;
  final String dateCreated;
  final String dateModified;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.sensorCount,
    required this.dateCreated,
    required this.dateModified,
  });

  // Factory constructor to create a Channel object from JSON
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['channel_id'],
      name: json['channel_name'],
      description: json['description'],
      sensorCount: json['sensor_count'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
    );
  }
}

// Function to fetch channels from the backend
Future<List<Channel>> fetchChannels() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/mychannel/'), // URL to fetch channels
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (jsonData['success'] == true && jsonData.containsKey('channels')) {
      final List<dynamic> channelData = jsonData['channels']; // Extract the channels list
      return channelData.map((data) => Channel.fromJson(data)).toList();
    } else {
      throw Exception('No channels found in response');
    }
  } else {
    throw Exception('Failed to fetch channels');
  }
}