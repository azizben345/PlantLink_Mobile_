import 'package:flutter/material.dart';
import 'package:plantlink_mobile_/channel_page.dart';
import 'package:plantlink_mobile_/profile_page.dart';
import 'package:plantlink_mobile_/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Plant',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.green, // Set to match the AppBar color scheme
                  fontSize: 25, // Adjust as needed
                ),
              ),
              TextSpan(
                text: 'Link',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey, // Different color for "Link" if desired
                  fontSize: 25, // Match the font size
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Track Your Crop Sensor.',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Create your channel, connect your sensor, and monitor your soil data in a visualized chart!',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LoginPage(),
                                  builder: (context) => ChannelPage()
                                ),
                              );
                            },
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 18),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 12.0,
                              ),
                            ),
                            child: const Text('Start now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Image.asset(
                      'assets/home_asset.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Welcome, [User’s Name]',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Close drawer and stay on the Home page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('My Channel'),
              onTap: () {
                // Navigate to My Channel Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChannelPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout functionality here
                // For now, close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}