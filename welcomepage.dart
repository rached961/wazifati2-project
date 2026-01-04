import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'registrationpage.dart';
import 'homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorText = '';
  bool isLoading = false;

  final String apiUrl = "http://wazifati.atwebpages.com/login.php"; // ✅ use http

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      errorText = '';
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": email,
          "password": password,
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded["success"].toString())),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          errorText = decoded["error"]?.toString() ?? "Login failed";
        });
      }
    } catch (e) {
      setState(() {
        errorText = "Request failed: $e";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void openRegistration() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wazeefati'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Login to your account',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),

            // Email
            SizedBox(
              width: 250.0,
              height: 50.0,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            // Password
            SizedBox(
              width: 250.0,
              height: 50.0,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            // Error text
            Text(
              errorText,
              style: const TextStyle(fontSize: 16.0, color: Colors.red),
            ),

            const SizedBox(height: 20.0),

            // Login button
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              child: isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text(
                'Login',
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            const SizedBox(height: 10.0),

            // Register button
            ElevatedButton(
              onPressed: openRegistration,
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
