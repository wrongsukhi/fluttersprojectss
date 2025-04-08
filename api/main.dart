import 'package:flutter/material.dart';
import 'api_service.dart';
import 'database_service.dart';
import 'add_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Record',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
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
    ResultPage(),
    AddDetailsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Result' : 'Add Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Academic Record',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Result'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Details'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ApiService apiService = ApiService();
  final DatabaseService dbService = DatabaseService();
  List<Map<String, dynamic>> grades = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadLocalData();
  }

  Future<void> loadLocalData() async {
    try {
      final localGrades = await dbService.getGrades();
      setState(() {
        grades = localGrades;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading local data: $e')),
      );
    }
  }

  Future<void> fetchAndSaveData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedGrades = await apiService.fetchGrades();
      await dbService.saveGrades(fetchedGrades);
      await loadLocalData();
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data loaded successfully')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> eraseData() async {
    await dbService.eraseAllData();
    setState(() {
      grades = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All data erased')),
    );
  }

  Future<void> deleteItem(int id) async {
    await dbService.deleteGrade(id);
    await loadLocalData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Course record deleted')),
    );
  }

  @override
  void dispose() {
    dbService.close();
    super.dispose();
  }

  Map<String, List<Map<String, dynamic>>> groupBySemester() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var grade in grades) {
      final semester = grade['mysemester'];
      if (!grouped.containsKey(semester)) {
        grouped[semester] = [];
      }
      grouped[semester]!.add(grade);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedGrades = groupBySemester();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.indigo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.cloud_download),
                label: Text('Load Data'),
                onPressed: isLoading ? null : fetchAndSaveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete_sweep),
                label: Text('Erase All'),
                onPressed: eraseData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        if (grades.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Student: ${grades[0]['studentname']}', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 4),
                    Text('Father: ${grades[0]['fathername']}'),
                    Text('Program: ${grades[0]['progname']} (${grades[0]['shift']})'),
                    Text('Roll No: ${grades[0]['rollno']}'),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : grades.isEmpty
                  ? Center(
                      child: Text(
                        'No academic records available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: groupedGrades.keys.length,
                      itemBuilder: (context, index) {
                        final semester = groupedGrades.keys.elementAt(index);
                        final semesterGrades = groupedGrades[semester]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                'Semester $semester',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            ...semesterGrades.map((grade) => Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                grade['coursetitle'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.indigo[800],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => deleteItem(grade['id']),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        _buildInfoRow('Course Code', grade['coursecode']),
                                        _buildInfoRow('Credit Hours', grade['credithours']),
                                        _buildInfoRow(
                                          'Marks',
                                          grade['obtainedmarks'].isEmpty ? 'Pending' : grade['obtainedmarks'],
                                        ),
                                        _buildInfoRow('Status',
                                            grade['consider_status'] == 'E' ? 'Enrolled' : 'Not Available'),
                                      ],
                                    ),
                                  ),
                                )).toList(),
                          ],
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}