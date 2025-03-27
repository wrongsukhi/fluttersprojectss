import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const WelcomePage({super.key, required this.userData});

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(child: Column(children: [Text("Hello, ${userData['name']}!"), ElevatedButton(onPressed: () => _logout(context), child: const Text("Logout"))])),
    );
  }
}
