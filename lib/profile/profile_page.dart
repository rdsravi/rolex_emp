import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator

class ProfilePage extends StatelessWidget {
  // Sample user data
  final String profilePictureUrl =
      'https://example.com/profile_picture.png'; // Replace with the actual URL
  final String name = 'John Doe';
  final String mobileNumber = '123-456-7890';
  final String email = 'john.doe@example.com';
  final String gender = 'Male';
  final bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: profilePictureUrl.isNotEmpty
                    ? NetworkImage(profilePictureUrl)
                    : AssetImage('assets/images/avatar.png') as ImageProvider, // Use asset image if URL is empty
              ),
            ),
            SizedBox(height: 16),
            // User Details Header
            Text(
              'User Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 2),
            SizedBox(height: 10),
            // User Info
            _buildUserInfo('Name', name),
            _buildUserInfo('Mobile No', mobileNumber),
            _buildUserInfo('Email', email),
            _buildUserInfo('Gender', gender),
            SizedBox(height: 20),
            // Notifications Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    // Handle notification toggle
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build user info rows
  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear user session (e.g., shared preferences)
                // Example: await SharedPreferences.getInstance().then((prefs) => prefs.clear());

                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Perform the logout action
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Logout method
  void _logout() {
    // Implement logout logic here
    // e.g., clear user session and close the app
    SystemNavigator.pop(); // Close the app
  }
}

// Placeholder for Edit Profile Page
class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Page'), // Add your edit profile fields here
      ),
    );
  }
}
