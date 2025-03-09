import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student App',
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
    StudentDetailsPage(),
    BodmasCalculatorPage(),
  ];

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student App")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.school, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text("Student App", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text("Student Details"),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.calculate, color: Colors.green),
              title: const Text("BODMAS Calculator"),
              onTap: () => _onSelectItem(1),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// 📌 Student Details Page (Your Details)
class StudentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        color: Colors.blue.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("👨‍🎓 Name: Sukhdeep Singh", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("📌 Roll No: BSCSF22M29", style: TextStyle(fontSize: 18)),
              Text("📚 Course: BSCS", style: TextStyle(fontSize: 18)),
              Text("📆 Year: 2022 - Present", style: TextStyle(fontSize: 18)),
              Text("📧 Email: sukhdeep.singh@example.com", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

// 📌 BODMAS Calculator with Buttons
class BodmasCalculatorPage extends StatefulWidget {
  @override
  _BodmasCalculatorPageState createState() => _BodmasCalculatorPageState();
}

class _BodmasCalculatorPageState extends State<BodmasCalculatorPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";

  void _calculate() {
    String input = _controller.text;
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = "Result: $eval";
      });
    } catch (e) {
      setState(() {
        _result = "Invalid Expression!";
      });
    }
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = "";
    });
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _controller.text += text;
          });
        },
        child: Text(text, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("BODMAS Calculator", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter Expression",
              prefixIcon: Icon(Icons.calculate, color: Colors.green),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
              _buildButton("/"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
              _buildButton("*"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
              _buildButton("-"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton("0"),
              _buildButton("."),
              _buildButton("+"),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text("=", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _clear,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          const SizedBox(height: 10),
          Text(_result, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        ],
      ),
    );
  }
}


