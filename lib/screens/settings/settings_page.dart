import 'package:dating/screens/feedback/feedback_screen.dart';
import 'package:dating/screens/notifications/notifications.dart';
import 'package:dating/screens/settings/videoAutoPlayScreen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("settings", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _greenButtonTile("Add Your Email", "Sign Up to Be Notified With Important Event Type Updates"),
            const SizedBox(height: 16),
            _tileWithTextArrow("Type Of Connection", "Date"),
            const SizedBox(height: 16),
            _tileWithSwitch("Date Mode",  true),
            const SizedBox(height: 8),
            Text('Hide your Profile in Date And just use BFF or BIZZ. If you Do This you Will Loss Your Connections And Chats In Date'),
            const SizedBox(height: 16),
            _tileWithSwitch("Snooze Mode", false),
            const SizedBox(height: 8),
            Text('Hide Your Profile Temporarily, in All Modes You Won’t Loss Any Connections And Chats'),
            const SizedBox(height: 16),
            _tileWithSwitch("Incognito Mode For Date", false),
            const SizedBox(height: 8),
             Text('Only People You’ve Swiped Raight on Already Or Swipe Right On Later Will See You Profile .If You Turn On Incognito Mode For Date THis Won’t Apply Bizz or BFF  '),
            const SizedBox(height: 16),
            _tileWithSwitch("Auto - Spotlight",  false),
            const SizedBox(height: 8),
             Text('We’ll Use Spotlight Automatically TO Boost Your Profile When Most People See It.'),
            const SizedBox(height: 16),
            Text('Location'),
             const SizedBox(height: 16),
            _tileWithText("Current Location", "Anonymous - India"),
            const SizedBox(height: 8),
            _tileWithArrow("Travel", ),
            const SizedBox(height: 8),
            Text('Change Your Location To Connect With People In Other Locations'),
            const SizedBox(height: 8),
           
            _simpleArrowTile("Video Autoplay Settings",(){
             Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VideoAutoplayScreen()),
                        );
                       }),
           _simpleArrowTile("Notification Setting",(){
            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NotificationsScreen()),
                        );
                       }),
             
            _simpleArrowTile("Payment Setting",(){
               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Feedbackpage()),
                        );
            }),
            _simpleArrowTile("Content And FAQ",(){}),
            _simpleArrowTile("Security And Privacy",(){}),
            const SizedBox(height: 16),
            _button("Log Out",const Color.fromARGB(255, 59, 124, 18),Colors.white),
            const SizedBox(height: 10),
            _button("Delete Account",  Color(0xffE9F1C4), Colors.black),
            const SizedBox(height: 20),
            const Text("Ever Qupid", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Version 6.4.0.0\nCreated With Love.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _greenButtonTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F1C8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _tileWithTextArrow(String title, String value) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: const Color(0xFFF5F5F5),
      title: Text(title),
      trailing: Text(value),
    );
  }

  Widget _tileWithSwitch(String title, bool value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                // Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }

  Widget _tileWithText(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _tileWithArrow(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green,
            child: Icon(Icons.travel_explore, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                // Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }

  Widget _simpleArrowTile(String title,VoidCallback onTap) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 59, 124, 18)),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
