import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/notifications/expiring_matches_screen.dart';
import 'package:dating/screens/notifications/new_admirers_screen.dart';
import 'package:dating/screens/notifications/new_matches_screen.dart';
import 'package:dating/screens/notifications/new_messagea_screen.dart';
import 'package:dating/screens/notifications/researchandsurveys.dart';
import 'package:dating/screens/notifications/the_good_stuff.dart';
import 'package:dating/screens/notifications/top_profile_tips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
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
          border: Border.all(color: Color.fromARGB(255, 220, 113, 145)), // Green border
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
  Widget descriptionText(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
      child: Text(
        text,
        style:  TextStyle(fontSize: 12, color: isDarkMode ? DatingColors.lightgrey : Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // App Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDarkMode ? DatingColors.white : DatingColors.black),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: isDarkMode ? DatingColors.white : DatingColors.black,
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
              "Turning off this notification means you will miss out on new messages from your connections.",isDarkMode
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
              "Turning off this notification means you will miss out on your new or expiring matches.", isDarkMode
            ),

            // Section 3: Profile Notifications
            sectionTitle("Profile Notifications"),
            capsuleButton("Top Profile Tips", () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TopProfileTips()),
                        );
            }),
            descriptionText(
              "Turning off this notification means you will not be notified of tips and tricks for maximising your Heart Sync experience.",isDarkMode
            ),

            // Section 4: Other Notifications
            sectionTitle("Other Notifications"),
            capsuleButton("Heart Events", () {}),
            capsuleButton("The Good Stuff", () {
               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TheGoodStuff()),
                        );
            }),
            capsuleButton("Research And Surveys", () {
               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Researchandsurveys()),
                        );
            }),
            descriptionText(
              "Turning off this notification means you will not be notified of special Heart Sync events held in your area.",isDarkMode
            ),
          ],
        ),
      ),
    );
  }
}
