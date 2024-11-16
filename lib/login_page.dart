import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantlink_mobile_/channel_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Please login to use PlantLink',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@example.com',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email!';
                    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                      return 'Enter a valid email address!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 8 characters',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password!';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long!';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                      textAlign: TextAlign.end,
                    ),
                  ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

      // backend validation
      Future<void> storeToken(String token) async {
        // Store token using Flutter's secure storage package
        // Add `flutter_secure_storage` to your pubspec.yaml
        final storage = FlutterSecureStorage();
        await storage.write(key: 'auth_token', value: token);
      }

      Future<void> login() async {
        if (_formKey.currentState?.validate() ?? false) {
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();

          final url = Uri.parse('http://127.0.0.1:8000/login/'); // Update with your actual backend URL

          try {
            final response = await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email, 'password': password}),
            );

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              final token = data['token']; // Assume the backend returns a JWT or similar token

              // Store the token securely
              await storeToken(token);

              // Navigate to the channels page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChannelPage()),
              );
            } else {
              setState(() {
                _errorMessage = 'Your email or password is incorrect!';
              });
            }
          } catch (error) {
            setState(() {
              _errorMessage = 'An error occurred. Please try again later.';
            });
          }
        }
      }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}