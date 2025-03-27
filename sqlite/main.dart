import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'signup_page.dart';
import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userEmail = prefs.getString('loggedInEmail');

  Map<String, dynamic>? userData;
  if (isLoggedIn && userEmail != null) {
    final dbHelper = DatabaseHelper();
    userData = await dbHelper.getUserByEmail(userEmail);
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, userData: userData));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Map<String, dynamic>? userData;

  const MyApp({super.key, required this.isLoggedIn, this.userData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Authentication',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: isLoggedIn ? WelcomePage(userData: userData!) : const SignupPage(),
    );
  }
}
