import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drawer Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NamePage(),
    ButtonPage(),
    NameAndButtonPage(),
    FriendsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close the drawer after selecting an item
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drawer Example")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text("Name"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              title: Text("Button"),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              title: Text("Name and Button"),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              title: Text("Friends"),
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// Page 1: Displays "Sukhdeep"
class NamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Sukhdeep",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Page 2: Displays a button labeled "Enter"
class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text("Enter"),
      ),
    );
  }
}

// Page 3: Displays both "Sukhdeep" and the "Enter" button
class NameAndButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Sukhdeep",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("Enter"),
          ),
        ],
      ),
    );
  }
}

// Page 4: Displays names and changes them when the button is pressed
class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<String> _friends = ["Sukhdeep", "Sarmad", "Sharjeel", "Hamza", "Afaq"];
  int _currentIndex = 0;

  void _changeName() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _friends.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _friends[_currentIndex],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _changeName,
            child: Text("Change Name"),
          ),
        ],
      ),
    );
  }
}
