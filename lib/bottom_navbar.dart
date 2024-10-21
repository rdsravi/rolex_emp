import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolex_emp/controllers/bottom_nav_controller.dart';
import 'package:rolex_emp/home_page.dart';
import 'package:rolex_emp/attendance/attendance_page.dart';
import 'package:rolex_emp/profile/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavController bottomNavController = Get.put(BottomNavController());

  final List<Widget> screens = [
    HomePage(),
    AttendancePage(),
    ProfilePage(), // Assuming ProfilePage is created or renamed from Business
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: bottomNavController.selectedIndex.value,
        children: screens,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: bottomNavController.selectedIndex.value,
        selectedItemColor: Colors.blueAccent,
        onTap: bottomNavController.onItemTapped,
      )),
    );
  }
}
