class AttendanceRecord {
  final String studentId;
  final String status;
  final DateTime timestamp;

  AttendanceRecord({
    required this.studentId,
    required this.status,
    required this.timestamp,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json, String studentId) {
    return AttendanceRecord(
      studentId: studentId,
      status: json['status'] ?? 'Absent',
      timestamp: json['timestamp'] != null 
          ? (json['timestamp'] as dynamic).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
    };
  }
}
