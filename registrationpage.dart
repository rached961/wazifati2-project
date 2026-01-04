import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import'welcomepage.dart';
import 'homepage.dart'; // make sure you have a HomePage widget

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int gender = 1; // 1 = male, 2 = female
  bool agree = false;

  String errorText = '';
  bool isLoading = false;

  // ✅ Your API URL
  final String apiUrl = "http://wazifati.atwebpages.com/registration.php";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final genderText = (gender == 1) ? "male" : "female";

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || !agree) {
      setState(() {
        errorText = 'Please fill all fields and agree to the terms';
      });
      return;
    }

    setState(() {
      errorText = '';
      isLoading = true;
    });

    try {
      // ✅ Send as form-data (simpler for PHP)
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "full_name": fullName,
          "email": email,
          "password": password,
          "gender": genderText,
        },
      );

      // Debug prints
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded["success"].toString())),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      } else {
        setState(() {
          errorText = decoded["error"]?.toString() ?? "Registration failed";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),

              // Full name
              SizedBox(
                width: 250.0,
                height: 50.0,
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 18.0),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Full name',
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

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

              // Gender
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gender', style: TextStyle(fontSize: 18.0)),
                  Radio<int>(
                    value: 1,
                    groupValue: gender,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => gender = val);
                    },
                  ),
                  const Text('Male', style: TextStyle(fontSize: 18.0)),
                  Radio<int>(
                    value: 2,
                    groupValue: gender,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => gender = val);
                    },
                  ),
                  const Text('Female', style: TextStyle(fontSize: 18.0)),
                ],
              ),

              // Terms checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (bool? value) {
                      if (value == null) return;
                      setState(() => agree = value);
                    },
                  ),
                  const Text('I agree to the terms', style: TextStyle(fontSize: 16.0)),
                ],
              ),

              const SizedBox(height: 10.0),

              // Error text
              Text(
                errorText,
                style: const TextStyle(fontSize: 16.0, color: Colors.red),
              ),

              const SizedBox(height: 20.0),

              // Register button
              ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                child: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Register', style: TextStyle(fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
