import 'package:flutter/material.dart';
import 'channel_card.dart';
import 'manage_sensors.dart';
import 'dashboard_page.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late Future<List<Channel>> _channels;

  @override
  void initState() {
    super.initState();
    _channels = fetchChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            onPressed: () async {
              try {
                final channels = await _channels; // Wait for channels to load
                if (channels.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageSensorsPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No channels to manage sensors.')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading channels: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Channel>>(
        future: _channels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final channels = snapshot.data!;
            return ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                return ChannelCard(
                  channel: channel,
                  onViewChannel: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(channelId: channel.id),
                      ),
                    );
                  },
                  onEditChannel: () {
                    // Placeholder for edit action
                    print('Edit channel: ${channel.name}');
                  },
                  onDeleteChannel: () {
                    // Placeholder for delete action
                    print('Delete channel: ${channel.name}');
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No channels found.'));
          }
        },
      ),
    );
  }
}

// class _ChannelPageState extends State<ChannelPage> {
//   late Future<List<Channel>> _channels;

//   @override
//   void initState() {
//     super.initState();
//     _channels = fetchChannels();
//   }

//   // Function to fetch channels from the backend
//   Future<List<Channel>> fetchChannels() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginPage(),
//         ),
//       );
//     }

//     final response = await http.get(
//       Uri.parse('http://127.0.0.1:8000/mychannel/'),
//       headers: {'Authorization': 'Bearer $token'}, // Send token in Authorization header
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> channelData = json.decode(response.body);
//       return channelData.map((data) => Channel.fromJson(data)).toList();
//     } else if (response.statusCode == 401) {
//       // Handle unauthorized error
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Unauthorized'),
//           content: const Text('Session expired. Please log in again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 //Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const LoginPage(),
//                   ),
//                 );
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       throw Exception('Unauthorized: Please log in again');
//     } else {
//       throw Exception('Failed to fetch channels');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Channel Details'),
//       ),
//       body: FutureBuilder<List<Channel>>(
//         future: _channels,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (snapshot.hasData) {
//             final channels = snapshot.data!;
//             return ListView.builder(
//               itemCount: channels.length,
//               itemBuilder: (context, index) {
//                 final channel = channels[index];
//                 return ChannelCard(
//                   channel: channel,
//                   onViewChannel: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DashboardScreen(channelId: channel.id),
//                       ),
//                     );
//                   },
//                   onEditChannel: () {
//                     // Handle edit action
//                   },
//                   onDeleteChannel: () {
//                     // Handle delete action
//                   },
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('No channels found.'));
//           }
//         },
//       ),
//     );
//   }
// }

