import 'package:flutter/material.dart';
import 'database_service.dart';

class AddDetailsPage extends StatefulWidget {
  @override
  _AddDetailsPageState createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService dbService = DatabaseService();

  final _studentNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _progNameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _creditHoursController = TextEditingController();
  final _obtainedMarksController = TextEditingController();
  String _shift = 'Morning'; // Default value for shift
  String _semester = '1'; // Default value for semester
  String _considerStatus = 'E';

  Future<void> _saveGrade() async {
    if (_formKey.currentState!.validate()) {
      final grade = {
        'studentname': _studentNameController.text,
        'fathername': _fatherNameController.text,
        'progname': _progNameController.text,
        'shift': _shift,
        'rollno': _rollNoController.text,
        'coursecode': _courseCodeController.text,
        'coursetitle': _courseTitleController.text,
        'credithours': _creditHoursController.text,
        'obtainedmarks': _obtainedMarksController.text.isEmpty ? '' : _obtainedMarksController.text,
        'mysemester': _semester,
        'consider_status': _considerStatus,
      };
      await dbService.addGrade(grade);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Record added successfully')),
      );
      _clearForm();
    }
  }

  void _clearForm() {
    _studentNameController.clear();
    _fatherNameController.clear();
    _progNameController.clear();
    _rollNoController.clear();
    _courseCodeController.clear();
    _courseTitleController.clear();
    _creditHoursController.clear();
    _obtainedMarksController.clear();
    setState(() {
      _shift = 'Morning';
      _semester = '1';
      _considerStatus = 'E';
    });
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _fatherNameController.dispose();
    _progNameController.dispose();
    _rollNoController.dispose();
    _courseCodeController.dispose();
    _courseTitleController.dispose();
    _creditHoursController.dispose();
    _obtainedMarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Academic Record', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            TextFormField(
              controller: _studentNameController,
              decoration: InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _fatherNameController,
              decoration: InputDecoration(labelText: 'Father Name', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _progNameController,
              decoration: InputDecoration(labelText: 'Program Name', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _shift,
              decoration: InputDecoration(labelText: 'Shift', border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: 'Morning', child: Text('Morning')),
                DropdownMenuItem(value: 'Evening', child: Text('Evening')),
              ],
              onChanged: (value) {
                setState(() {
                  _shift = value!;
                });
              },
              validator: (value) => value == null ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _rollNoController,
              decoration: InputDecoration(labelText: 'Roll No', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _courseCodeController,
              decoration: InputDecoration(labelText: 'Course Code', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _courseTitleController,
              decoration: InputDecoration(labelText: 'Course Title', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _creditHoursController,
              decoration: InputDecoration(labelText: 'Credit Hours', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _obtainedMarksController,
              decoration: InputDecoration(labelText: 'Obtained Marks (Optional)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return null; // Optional field
                final marks = int.tryParse(value);
                if (marks == null || marks < 0 || marks > 100) {
                  return 'Marks must be between 0 and 100';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _semester,
              decoration: InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
              items: List.generate(8, (index) => (index + 1).toString())
                  .map((semester) => DropdownMenuItem(value: semester, child: Text(semester)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _semester = value!;
                });
              },
              validator: (value) => value == null ? 'Required' : null,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _considerStatus,
              decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: 'E', child: Text('Enrolled')),
                DropdownMenuItem(value: 'NA', child: Text('Not Available')),
              ],
              onChanged: (value) {
                setState(() {
                  _considerStatus = value!;
                });
              },
              validator: (value) => value == null ? 'Required' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGrade,
              child: Text('Save Record'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}