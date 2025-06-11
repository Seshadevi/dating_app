import 'package:flutter/material.dart';

class TopProfileTips extends StatefulWidget {
  const TopProfileTips({super.key});

  @override
  State<TopProfileTips> createState() => _TopProfileTipsState();
}

class _TopProfileTipsState extends State<TopProfileTips> {
  bool pushNotification = true;
  bool emailNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Top Profile Tips',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Turning These Off Means You Will Not Be Notified Of Tips And Tricks For Maximising Your Heartsync Experience.",
              style: TextStyle(fontSize: 18),
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
