import 'package:flutter/material.dart';

class Researchandsurveys extends StatefulWidget {
  const Researchandsurveys({super.key});

  @override
  State<Researchandsurveys> createState() => _ResearchandsurveysState();
}

class _ResearchandsurveysState extends State<Researchandsurveys> {
  bool pushNotification = true;
  bool emailNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Research And Serveys',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Keep Up To Date With Paid And Non - Paid Research",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "Opportunities And Share Your Opinions On How To Improve.",
              style: TextStyle(fontSize: 16),
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
