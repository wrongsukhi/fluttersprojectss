import 'package:flutter/material.dart';
import 'first_screen.dart';
import 'second_screen.dart';
import 'third_screen.dart'; // ✅ Added Third Screen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Gallery',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "First Screen") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen()));
              } else if (value == "Second Screen") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondScreen()));
              } else if (value == "Third Screen") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ThirdScreen()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "First Screen", child: Text("First Screen")),
              const PopupMenuItem(value: "Second Screen", child: Text("Second Screen")),
              const PopupMenuItem(value: "Third Screen", child: Text("Third Screen")), // ✅ Third Screen Option
            ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView( // ✅ Prevents Overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Image Gallery App",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              _buildNavigationButton(context, "View Vertical Images", const FirstScreen()),
              const SizedBox(height: 15),
              _buildNavigationButton(context, "View Horizontal Images", const SecondScreen()),
              const SizedBox(height: 15),
              _buildNavigationButton(context, "View PageView Images", const ThirdScreen()), // ✅ Third Screen Button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, Widget screen) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }
}
