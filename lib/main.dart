import 'package:flutter/material.dart';
import 'grade.dart';
import 'database_service.dart';
import 'api_service.dart';

void main() => runApp(const GradeManagerApp());

class GradeManagerApp extends StatelessWidget {
  const GradeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFF1C2526),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const GradePage(),
    );
  }
}

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  List<Grade> grades = [];
  bool isLoading = false;
  final dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _refreshGrades();
  }

  Future<void> _refreshGrades() async {
    setState(() => isLoading = true);
    final loadedGrades = await dbService.getGrades();
    setState(() {
      grades = loadedGrades;
      isLoading = false;
    });
  }

  Future<void> _loadAndStoreData() async {
    setState(() => isLoading = true);
    try {
      final fetchedGrades = await ApiService.fetchGrades();
      if (fetchedGrades.isNotEmpty) {
        await dbService.deleteAllGrades();
        for (var grade in fetchedGrades) {
          await dbService.insertGrade(grade);
        }
      }
      await _refreshGrades();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAllData() async {
    await dbService.deleteAllGrades();
    await _refreshGrades();
  }

  Future<void> _deleteGrade(int id) async {
    await dbService.deleteGrade(id);
    await _refreshGrades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Records'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Column(
        children: [
          _buildActionButtons(),
          Expanded(child: _buildGradeList()),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : _loadAndStoreData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('LOAD DATA'),
          ),
          ElevatedButton(
            onPressed: isLoading ? null : _deleteAllData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ERASE DATA'),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeList() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (grades.isEmpty) return const Center(child: Text('No grades available'));

    return ListView.builder(
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              grade.getGradeLetter(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          title: Text(grade.studentName),
          subtitle: Text('${grade.courseTitle} - Marks: ${grade.obtainedMarks}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteGrade(grade.id),
          ),
        );
      },
    );
  }
}
