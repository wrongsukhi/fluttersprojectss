import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  List<Map<String, dynamic>> _users = [];

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      version: 1,
    );
  }

  Future<void> _loadUsers() async {
    final db = await _initDatabase();
    final users = await db.query('users');
    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved User Data')),
      body: _users.isEmpty
          ? Center(child: Text('No data available'))
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Username: ${_users[index]['username']}'),
                  subtitle: Text('Password: ${_users[index]['password']}'),
                );
              },
            ),
    );
  }
}