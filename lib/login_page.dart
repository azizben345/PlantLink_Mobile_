import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'channel_page.dart';

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
  bool _isLoading = false;

  // Secure storage instance
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
                    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value)) {
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
                    //hintText: 'At least 8 characters',
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
                      style:
                          const TextStyle(color: Colors.red, fontSize: 14.0),
                      textAlign: TextAlign.end,
                    ),
                  ),
                const SizedBox(height: 24.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
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

  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final url = Uri.parse('http://127.0.0.1:8000/api/login/'); // Backend URL

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Ensure token exists
          if (data.containsKey('token') && data['token'] != null) {
            final token = data['token'];
            await storeToken(token);

            // Navigate to ChannelPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChannelPage()),
            );
          } else {
            setState(() {
              _errorMessage = 'Invalid server response: Missing token';
            });
          }
        } else if (response.statusCode == 401) {
          setState(() {
            _errorMessage = 'Invalid credentials. Please try again.';
          });
        } else {
          setState(() {
            _errorMessage = 'Unexpected error: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Unable to connect to the server. Check your network.';
        });
      } finally {
        setState(() {
          _isLoading = false;
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
