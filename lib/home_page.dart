import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your own asset
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Jane Doe', // Placeholder name
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'You have 1 Pendding Site',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add action for "Use Now" button
                },
                child: Text("Active"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true, // Ensures GridView takes only the necessary height
              physics: NeverScrollableScrollPhysics(), // Disable independent scrolling
              children: [
                buildSummaryContainer(
                  context,
                  icon: Icons.time_to_leave,
                  title: 'Leave',
                  count: '0',
                ),
                buildSummaryContainer(
                  context,
                  icon: Icons.attach_money,
                  title: 'Salary',
                  count: '1',
                ),
                buildSummaryContainer(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Absence',
                  count: '1',
                ),
                buildSummaryContainer(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'completed site work',
                  count: '1',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Current Client',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/employee_image.png'), // Replace with actual employee image
                ),
                title: Text('Jhon smith'),
                subtitle: Text('Pendding'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add action for tapping employee tile
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Working Place',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.greenAccent[700],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Working Site',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Click to accept the site',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add action for the plan button
                      },
                      child: Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black12, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true, // Ensures GridView takes only the necessary height
                physics: NeverScrollableScrollPhysics(), // Disable independent scrolling
                children: [
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/camera');
                    },
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    gradientColors: [Colors.greenAccent, Colors.lightGreen],
                  ),
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/attendance');
                    },
                    icon: Icons.assignment_turned_in,
                    title: 'Attendance',
                    gradientColors: [Colors.greenAccent, Colors.green],
                  ),
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/calendar');
                    },
                    icon: Icons.date_range,
                    title: 'Calendar',
                    gradientColors: [Colors.grey, Colors.black45],
                  ),
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/gallery');
                    },
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    gradientColors: [Colors.blueGrey, Colors.deepPurple],
                  ),
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/leaves');
                    },
                    icon: Icons.nature_people,
                    title: 'Leaves',
                    gradientColors: [Colors.lightGreen, Colors.green],
                  ),
                  buildContainer(
                    context,
                    onTap: () {
                      Navigator.of(context).pushNamed('/working_site');
                    },
                    icon: Icons.location_on,
                    title: 'My Working Site',
                    gradientColors: [Colors.blueAccent, Colors.blue],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the container with consistent design
  Widget buildContainer(
      BuildContext context, {
        required VoidCallback onTap,
        required IconData icon,
        required String title,
        required List<Color> gradientColors,
      }) {
    return InkWell(
      onTap: onTap,
      splashColor: gradientColors[0].withOpacity(1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryContainer(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String count,
      }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
