import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rolex_emp/attendance/attendance_page.dart';
import 'package:rolex_emp/calendar_page.dart';
import 'package:rolex_emp/camera_page.dart';
import 'package:rolex_emp/gallery_page.dart';
import 'package:rolex_emp/leaves/leaves_page.dart';
import 'firebase_options.dart';
import 'package:rolex_emp/splash_screen.dart';
import 'package:rolex_emp/login/login_page.dart';
import 'package:rolex_emp/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'New Way App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => BottomNavBar()),
        GetPage(name: '/camera', page: () => CameraPage()),
        GetPage(name: '/attendance', page: () => AttendancePage()),
        GetPage(name: '/calendar', page: () => CalendarPage(attendanceList: [],)),
        GetPage(name: '/gallery', page: () => GalleryPage()),
        GetPage(name: '/leaves', page: () => LeavesPage()),
      ],
    );
  }
}
