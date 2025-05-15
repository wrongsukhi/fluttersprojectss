import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'input_screen.dart';
import 'display_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/input': (context) => InputScreen(),
        '/display': (context) => DisplayScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Enter Data'),
              onTap: () {
                Navigator.pushNamed(context, '/input');
              },
            ),
            ListTile(
              title: Text('View Data'),
              onTap: () {
                Navigator.pushNamed(context, '/display');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome to User Data App')),
    );
  }
}