import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'attendance_screen.dart';
import 'reports_screen.dart';
import 'add_student_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'Student Attendance System',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Lottie.network(
                        'https://lottie.host/81f8ffdc-f3c9-46f3-a1c8-2b85d92df958/P4vX4U5l4m.json',
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 50,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cards Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      // Attendance Card
                      _buildActionCard(
                        context,
                        title: 'Student Attendance',
                        subtitle: 'Mark daily student attendance.',
                        icon: Icons.checklist_rtl_rounded,
                        buttonText: 'Start Attendance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AttendanceScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Monthly Progress Chart
                      const Text(
                        'Monthly Attendance Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildAttendanceChart(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reports Card
                      _buildActionCard(
                        context,
                        title: 'Attendance Reports',
                        subtitle: 'View daily and monthly attendance reports.',
                        icon: Icons.bar_chart_rounded,
                        buttonText: 'View Reports',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReportsScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Add Student Card
                      _buildActionCard(
                        context,
                        title: 'Add Student',
                        subtitle: 'Register a new student.',
                        icon: Icons.person_add_alt_1_rounded,
                        buttonText: 'Add New',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddStudentScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: AppTheme.primaryBlue, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Consumer<FirestoreService>(
      builder: (context, firestoreService, child) {
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: firestoreService.getAttendanceSummaries(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data yet.'));
            }

            final data = snapshot.data!;
            final recentData = data.length > 7
                ? data.sublist(data.length - 7)
                : data;

            List<BarChartGroupData> barGroups = [];
            for (int i = 0; i < recentData.length; i++) {
              final doc = recentData[i];
              final present = doc['present'] as int? ?? 0;

              barGroups.add(
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: present.toDouble(),
                      color: AppTheme.primaryBlue,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }

            return BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < recentData.length) {
                          final dateStr =
                              recentData[value.toInt()]['date'] as String;
                          final parts = dateStr.split('-');
                          if (parts.length == 3) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${parts[2]}/${parts[1]}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                      reservedSize: 22,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} Students',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
