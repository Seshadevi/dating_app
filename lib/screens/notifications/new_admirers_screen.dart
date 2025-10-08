import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewAdmirersScreen extends ConsumerStatefulWidget {
  const NewAdmirersScreen({super.key});

  @override
  ConsumerState<NewAdmirersScreen> createState() => _NewAdmirersScreenState();
}

class _NewAdmirersScreenState extends ConsumerState<NewAdmirersScreen> {
  bool pushNotification = true;
  bool emailNotification = true;

  @override
  Widget build(BuildContext context) {

    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
     // Theme,
     backgroundColor: isDarkMode ? DatingColors.black : DatingColors.backgroundWhite,
      appBar: AppBar(
       // Theme,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDarkMode ? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'New Admirers',
          style: TextStyle(color:  isDarkMode ? DatingColors.white : DatingColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? DatingColors.black : DatingColors.backgroundWhite,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
              "Turning these off might mean you miss alerts from your connections",
              style: TextStyle(fontSize: 14,color: isDarkMode ? DatingColors.white : DatingColors.black, ),
            ),
            const SizedBox(height: 24),

            // Push Notifications
            _toggleTile(
              title: "Push Notifications",
              value: pushNotification,
              onChanged: (val) {
                setState(() => pushNotification = val);
              },
            ),

            const SizedBox(height: 16),

            // Email Notifications
            _toggleTile(
              title: "Email",
              value: emailNotification,
              onChanged: (val) {
                setState(() => emailNotification = val);
              },
            ),

            const SizedBox(height: 24),

            const Text(
              "You'll receive emails at",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "kri*******@gmail.com",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to email change screen
              },
              child: const Text(
                "Change Email Address?",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CAD00), // Light green
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF9CAD00)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF4D5D00), // Dark green track
            inactiveTrackColor: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
