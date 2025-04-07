class Grade {
  final int id;
  final String studentName;
  final String fatherName;
  final String progName;
  final String shift;
  final String rollno;
  final String courseCode;
  final String courseTitle;
  final double creditHours;
  final double obtainedMarks;
  final String mySemester;
  final String considerStatus;

  Grade({
    required this.id,
    required this.studentName,
    required this.fatherName,
    required this.progName,
    required this.shift,
    required this.rollno,
    required this.courseCode,
    required this.courseTitle,
    required this.creditHours,
    required this.obtainedMarks,
    required this.mySemester,
    required this.considerStatus,
  });

  // Convert database map to Grade object
  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'] as int,
      studentName: map['studentName'] as String,
      fatherName: map['fatherName'] as String,
      progName: map['progName'] as String,
      shift: map['shift'] as String,
      rollno: map['rollno'] as String,
      courseCode: map['courseCode'] as String,
      courseTitle: map['courseTitle'] as String,
      creditHours: (map['creditHours'] as num).toDouble(),
      obtainedMarks: (map['obtainedMarks'] as num).toDouble(),
      mySemester: map['mySemester'] as String,
      considerStatus: map['considerStatus'] as String,
    );
  }

  // Convert JSON data to Grade object
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as int,
      studentName: json['studentName'] as String,
      fatherName: json['fatherName'] as String,
      progName: json['progName'] as String,
      shift: json['shift'] as String,
      rollno: json['rollno'] as String,
      courseCode: json['courseCode'] as String,
      courseTitle: json['courseTitle'] as String,
      creditHours: (json['creditHours'] as num).toDouble(),
      obtainedMarks: (json['obtainedMarks'] as num).toDouble(),
      mySemester: json['mySemester'] as String,
      considerStatus: json['considerStatus'] as String,
    );
  }

  // Convert Grade object to a map
  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'fatherName': fatherName,
      'progName': progName,
      'shift': shift,
      'rollno': rollno,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'creditHours': creditHours,
      'obtainedMarks': obtainedMarks,
      'mySemester': mySemester,
      'considerStatus': considerStatus,
    };
  }

  // Add a helper method for grade calculation (optional, based on your requirement)
  String getGradeLetter() {
    if (obtainedMarks >= 80) {
      return 'A';
    } else if (obtainedMarks >= 65) {
      return 'B';
    } else if (obtainedMarks >= 50) {
      return 'C';
    } else {
      return 'D';
    }
  }
}
