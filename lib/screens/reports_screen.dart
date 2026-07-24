import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/attendance_model.dart';
import '../models/student_model.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Student>>(
        stream: firestoreService.getStudents(),
        builder: (context, studentSnapshot) {
          if (!studentSnapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final students = studentSnapshot.data!;

          return StreamBuilder<List<AttendanceRecord>>(
            stream: firestoreService.getAttendanceForDate(_selectedDate),
            builder: (context, attendanceSnapshot) {
              if (attendanceSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final records = attendanceSnapshot.data ?? [];
              final int total = students.length;
              final int present = records
                  .where((r) => r.status == 'Present')
                  .length;
              // If records are present, we calculate missing as absent.
              final int absent = total - present;
              final double percentage = total > 0
                  ? (present / total) * 100
                  : 0.0;

              return Column(
                children: [
                  // Date Picker Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat(
                              'EEEE, MMM d, yyyy',
                            ).format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ),

                  // Stats Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Total', total.toString(), Colors.blue),
                        _buildStatCard(
                          'Present',
                          present.toString(),
                          Colors.green,
                        ),
                        _buildStatCard('Absent', absent.toString(), Colors.red),
                        _buildStatCard(
                          '%',
                          '${percentage.toStringAsFixed(1)}%',
                          AppTheme.primaryPurple,
                        ),
                      ],
                    ),
                  ),

                  // List of Records
                  Expanded(
                    child: records.isEmpty
                        ? const Center(
                            child: Text(
                              'No attendance recorded for this date.',
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              final match = records
                                  .where((r) => r.studentId == student.id)
                                  .toList();
                              final status = match.isNotEmpty
                                  ? match.first.status
                                  : 'Unmarked (Absent)';
                              final isPresent = status == 'Present';

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'City: ${student.city.isNotEmpty ? student.city : 'No City'}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: isPresent
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'Ab',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
