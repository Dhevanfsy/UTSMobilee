import 'package:flutter/material.dart';

void main() => runApp(ProfileApp());

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Profile',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://example.com/your_profile_picture.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Flutter Developer',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.email),
                SizedBox(width: 10),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 10),
                Text(
                  '+1 123 456 7890',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
