import 'package:dating/screens/notifications/expiring_matches_screen.dart';
import 'package:dating/screens/notifications/new_admirers_screen.dart';
import 'package:dating/screens/notifications/new_matches_screen.dart';
import 'package:dating/screens/notifications/new_messagea_screen.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Capsule-style button
  Widget capsuleButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFF9CAD00)), // Green border
          borderRadius: BorderRadius.circular(30), // Capsule shape
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // Section title
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Description below buttons
  Widget descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose how you'd like us to keep in touch.",
              style: TextStyle(fontSize: 12),
            ),

            // Section 1: Message Notifications
            sectionTitle("Message Notifications"),
            capsuleButton("New Messages", () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewMessagesSettingsScreen()),
                        );
            }),
            descriptionText(
              "Turning off this notification means you will miss out on new messages from your connections.",
            ),

            // Section 2: Match Notifications
            sectionTitle("Match Notifications"),
            capsuleButton("New Admirers", () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewAdmirersScreen()),
                        );
            }),
            capsuleButton("New Matches", () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewMatchesScreen()),
                        );
            }),
            capsuleButton("Expiring Matches", () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewExpiringMatchesScreen()),
                        );
            }),
            descriptionText(
              "Turning off this notification means you will miss out on your new or expiring matches.",
            ),

            // Section 3: Profile Notifications
            sectionTitle("Profile Notifications"),
            capsuleButton("Top Profile Tips", () {}),
            descriptionText(
              "Turning off this notification means you will not be notified of tips and tricks for maximising your Heart Sync experience.",
            ),

            // Section 4: Other Notifications
            sectionTitle("Other Notifications"),
            capsuleButton("Heart Events", () {}),
            capsuleButton("The Good Stuff", () {}),
            capsuleButton("Research And Surveys", () {}),
            descriptionText(
              "Turning off this notification means you will not be notified of special Heart Sync events held in your area.",
            ),
          ],
        ),
      ),
    );
  }
}
