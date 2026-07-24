import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/firestore_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        title: 'Student Attendance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const InitializerWidget(),
      ),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({super.key});

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _checkDummyData();
  }

  void _checkDummyData() async {
    // Just simulate a small delay for initialization or keep it simple
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }
    return const DashboardScreen();
  }
}
