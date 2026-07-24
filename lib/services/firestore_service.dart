import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/attendance_model.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all students
  Stream<List<Student>> getStudents() {
    return _db.collection('students').orderBy('name').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromJson(doc.data(), doc.id)).toList());
  }

  // Add a new student
  Future<void> addStudent(String name, String city) async {
    await _db.collection('students').add({
      'name': name,
      'city': city,
    });
  }

  // Save attendance for a date
  Future<void> saveAttendance(DateTime date, Map<String, String> attendanceData) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final batch = _db.batch();
    
    // We store records in attendance/YYYY-MM-DD/records/studentId
    final recordsRef = _db.collection('attendance').doc(dateStr).collection('records');
    
    attendanceData.forEach((studentId, status) {
      final docRef = recordsRef.doc(studentId);
      batch.set(docRef, {
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
    
    // Also save a summary doc so we know this date has records
    batch.set(_db.collection('attendance').doc(dateStr), {
      'date': dateStr,
      'total': attendanceData.length,
      'present': attendanceData.values.where((s) => s == 'Present').length,
      'absent': attendanceData.values.where((s) => s == 'Absent').length,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Get attendance for a specific date
  Stream<List<AttendanceRecord>> getAttendanceForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _db.collection('attendance').doc(dateStr).collection('records').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => AttendanceRecord.fromJson(doc.data(), doc.id)).toList()
    );
  }
  
  // Get all attendance summaries for charts
  Stream<List<Map<String, dynamic>>> getAttendanceSummaries() {
    return _db.collection('attendance').orderBy('date').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList()
    );
  }
  

}
