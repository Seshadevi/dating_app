import 'package:flutter/material.dart';

class Securityandprivacy extends StatefulWidget {
  const Securityandprivacy({super.key});

  @override
  State<Securityandprivacy> createState() => SecurityandprivacyState();
}

class SecurityandprivacyState extends State<Securityandprivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security And Privacy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description text
            const Text(
              'Manage How You Can Safe And Securely Log In.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF666666),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            
            // Way You Can Log In section
            _buildMenuOption(
              title: 'Way You Can Log In',
              onTap: () {
                // Handle navigation to login options
                print('Navigate to Way You Can Log In');
              },
            ),
            const SizedBox(height: 30),
            
            // Privacy section header
            const Text(
              'Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Privacy Settings option
            _buildMenuOption(
              title: 'Privacy Settings',
              onTap: () {
                // Handle navigation to privacy settings
                print('Navigate to Privacy Settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 163, 181, 6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF666666),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}