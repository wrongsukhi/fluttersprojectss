import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isActive = true;
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedUsers = prefs.getStringList('users');

    setState(() {
      users = storedUsers?.map((user) {
            List<String> data = user.split(',');
            return {'name': data[0], 'email': data[1], 'status': data[2]};
          }).toList() ?? [];
    });
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = _isActive ? "Active" : "Inactive";

    Map<String, String> newUser = {
      'name': _nameController.text,
      'email': _emailController.text,
      'status': status
    };

    users.add(newUser);
    List<String> stringUsers =
        users.map((user) => '${user['name']},${user['email']},${user['status']}').toList();
    await prefs.setStringList('users', stringUsers);

    _nameController.clear();
    _emailController.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User registered successfully")),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "User Registration",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Status: "),
                        Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: _isActive,
                              onChanged: (bool? value) {
                                setState(() => _isActive = value!);
                              },
                            ),
                            Text("Active"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: false,
                              groupValue: _isActive,
                              onChanged: (bool? value) {
                                setState(() => _isActive = value!);
                              },
                            ),
                            Text("Inactive"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _saveUser,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Register", style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfilePage()),
                        );
                      },
                      child: Text("Go to My Profile", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedUsers = prefs.getStringList('users');

    setState(() {
      users = storedUsers?.map((user) {
            List<String> data = user.split(',');
            return {'name': data[0], 'email': data[1], 'status': data[2]};
          }).toList() ?? [];
    });
  }

  Color _getRowColor(String status) {
    return status == "Active" ? Colors.green[100]! : Colors.red[100]!;
  }

  Icon _getStatusIcon(String status) {
    return status == "Active"
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.cancel, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: users.isEmpty
          ? Center(child: Text("No users registered yet."))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  color: _getRowColor(users[index]['status']!),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: _getStatusIcon(users[index]['status']!),
                    title: Text(users[index]['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(users[index]['email']!),
                  ),
                );
              },
            ),
    );
  }
}