import 'package:flutter/material.dart';

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
                channel.dateCreated ?? 'N/A',  // Use 'dateCreated' field if present
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                channel.dateModified ?? 'N/A',  // Use 'dateModified' field if present
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

// Channel model class for data fetching
class Channel {
  final String id;
  final String name;
  final String description;
  final int sensorCount;
  final String? dateCreated;
  final String? dateModified;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.sensorCount,
    this.dateCreated,
    this.dateModified,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['channel_id'],
      name: json['channel_name'],
      description: json['description'],
      sensorCount: json['sensor_count'],
      dateCreated: json['date_created'],  // Assuming these keys exist
      dateModified: json['date_modified'],
    );
  }
}
