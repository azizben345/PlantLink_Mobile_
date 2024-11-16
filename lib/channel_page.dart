import 'package:flutter/material.dart';
import 'package:plantlink_mobile_/channel_card.dart';
import 'package:plantlink_mobile_/dashboard_page.dart';

class ChannelPage extends StatelessWidget {
  ChannelPage({super.key});

  // Sample list of Channel objects (you would typically fetch this from an API or database)
  final List<Channel> channels = [
    Channel(
      id: '1',
      name: 'My Channel',
      description: 'This is a description.',
      sensorCount: 5,
      dateCreated: '2024-11-01',
      dateModified: '2024-11-06',
    ),
    Channel(
      id: '2',
      name: 'Channel 2',
      description: 'This is another channel description.',
      sensorCount: 3,
      dateCreated: '2024-10-15',
      dateModified: '2024-11-05',
    ),
    // Add more channels as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: channels.length,  // The number of items in the list
          itemBuilder: (context, index) {
            final channel = channels[index];  // Get the channel from the list
            return ChannelCard(
              channel: channel,  // Pass the entire channel object
              onViewChannel: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),  // Navigate to DashboardPage
                  ),
                );
              },
              onEditChannel: () {
                // Handle edit action
              },
              onDeleteChannel: () {
                // Handle delete action
              },
            );
          },
        ),
      ),
    );
  }
}
