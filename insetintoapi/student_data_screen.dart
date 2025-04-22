import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'student_api_service.dart';

class StudentDataScreen extends StatefulWidget {
  const StudentDataScreen({super.key});

  @override
  _StudentDataScreenState createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _creditHourController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _semesterNoController = TextEditingController();

  final StudentApiService _apiService = StudentApiService();
  List<Course> _courses = [];
  List<StudentRecord> _studentsData = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final courses = await _apiService.fetchCourses();
      setState(() {
        _courses = courses;
        _selectedCourse = courses.isNotEmpty ? courses[0] : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchStudentData() async {
    if (_userIdController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a User ID';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final studentsData =
          await _apiService.fetchStudentData(_userIdController.text);
      setState(() {
        _studentsData = studentsData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitStudentData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourse == null) {
      setState(() {
        _errorMessage = 'Please select a course';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _apiService.submitStudentData(
        userId: _userIdController.text,
        courseName: _selectedCourse!.subjectName,
        creditHours: _creditHourController.text,
        marks: _marksController.text,
        semesterNo: _semesterNoController.text,
      );
      setState(() {
        _successMessage = 'Data added successfully!';
      });
      _formKey.currentState!.reset();
      _creditHourController.clear();
      _marksController.clear();
      _semesterNoController.clear();
      await _fetchStudentData();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data Management'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    _buildMessage(
                      message: _errorMessage!,
                      color: Colors.red,
                      icon: Icons.error_outline,
                    ),
                  if (_successMessage != null)
                    _buildMessage(
                      message: _successMessage!,
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                    ),
                  const SizedBox(height: 16),
                  _buildUserInputSection(),
                  const SizedBox(height: 20),
                  _buildStudentForm(),
                  const SizedBox(height: 20),
                  _buildStudentDataList(),
                ],
              ),
            ),
    );
  }

  Widget _buildMessage({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fetch Student Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter student user ID',
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a User ID' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchStudentData,
              child: const Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Student Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownSearch<Course>(
                items: _courses,
                selectedItem: _selectedCourse,
                itemAsString: (course) =>
                    "${course.subjectCode} - ${course.subjectName}",
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a course' : null,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Select Course',
                    prefixIcon: Icon(Icons.book),
                    hintText: 'Choose a course',
                  ),
                ),
                popupProps: PopupProps.dialog(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      labelText: 'Search course',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  dialogProps: DialogProps(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditHourController,
                decoration: const InputDecoration(
                  labelText: 'Credit Hours',
                  prefixIcon: Icon(Icons.hourglass_empty),
                  hintText: 'Enter credit hours (e.g., 3)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter credit hours';
                  }
                  final numValue = num.tryParse(value!);
                  if (numValue == null || numValue <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _marksController,
                decoration: const InputDecoration(
                  labelText: 'Marks',
                  prefixIcon: Icon(Icons.grade),
                  hintText: 'Enter marks (0-100)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter marks';
                  }
                  final numValue = num.tryParse(value!);
                  if (numValue == null || numValue < 0 || numValue > 100) {
                    return 'Please enter valid marks (0-100)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _semesterNoController,
                decoration: const InputDecoration(
                  labelText: 'Semester Number',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'Enter semester number (e.g., 1)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter semester number';
                  }
                  final numValue = num.tryParse(value!);
                  if (numValue == null || numValue <= 0) {
                    return 'Please enter a valid semester number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitStudentData,
                child: const Text('Submit Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentDataList() {
    if (_studentsData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No student data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Records',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _studentsData.length,
          itemBuilder: (context, index) {
            final student = _studentsData[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: ${student.userId}'),
                    Text('Credit Hours: ${student.creditHours}'),
                    Text('Marks: ${student.marks}'),
                    Text('Semester: ${student.semesterNo}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _creditHourController.dispose();
    _marksController.dispose();
    _semesterNoController.dispose();
    super.dispose();
  }
}