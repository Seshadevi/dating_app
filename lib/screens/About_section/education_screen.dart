import 'package:dating/screens/About_section/add_eduction_screen.dart';
import 'package:dating/screens/About_section/add_job_screen.dart';
import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Education',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/completeprofile'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'You Can Only Show One Job On Your Profile At a Time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('add a Education'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to the add job screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEducationScreen(), // Replace with your actual screen
                ),
              );
            },
          ),
          const Divider(height: 1),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

