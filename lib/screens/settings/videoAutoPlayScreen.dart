import 'package:flutter/material.dart';

class VideoAutoplayScreen extends StatefulWidget {
  const VideoAutoplayScreen({super.key});

  @override
  State<VideoAutoplayScreen> createState() => _VideoAutoplayScreenState();
}

class _VideoAutoplayScreenState extends State<VideoAutoplayScreen> {
  String selectedOption = "wifi_mobile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Video Autoplay",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Choose When Videos On\nHeartsync Should Autoplay.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Autoplay Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            autoplayOption(
              label: "On WIFI And Mobile Data",
              value: "wifi_mobile",
            ),
            const SizedBox(height: 12),
            autoplayOption(
              label: "On WIFI Only",
              value: "wifi_only",
            ),
            const SizedBox(height: 12),
            autoplayOption(
              label: "Never Autoplay Videos",
              value: "never",
            ),
          ],
        ),
      ),
    );
  }

  Widget autoplayOption({required String label, required String value}) {
    final isSelected = selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFB6CC00),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
