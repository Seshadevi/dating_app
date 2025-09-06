import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/logout_notitifier.dart';
import 'package:dating/provider/signupprocessProviders/modeProvider.dart';
import 'package:dating/screens/feedback/feedback_screen.dart';
import 'package:dating/screens/notifications/notifications.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/settings/contactand_faq.dart';
import 'package:dating/screens/settings/privacusetting_screen.dart';
import 'package:dating/screens/settings/typesOfconnections.dart';
import 'package:dating/screens/settings/videoAutoPlayScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/signupprocessmodels/modeModel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        title: const Text("settings", style: TextStyle(color: DatingColors.black)),
        centerTitle: true,
        backgroundColor: DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
          }
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _greenButtonTile("Add Your Email", "Sign Up to Be Notified With Important Event Type Updates"),
            const SizedBox(height: 16),
            GestureDetector(
            onTap: () {
              final loginModel = ref.watch(loginProvider);
              final user = loginModel.data!.first.user;
              final userModeValue = user?.mode;

              final modeList = ref.watch(modesProvider).data ?? [];

              // Get the full Data object (not just the value)
              final matchedMode = modeList.firstWhere(
                (mode) => mode.value == userModeValue,
                orElse: () => Data(id: 0, value: 'Not set'),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Typeofconnection(
                    selectedModeId: matchedMode.id ?? 0,
                    selectedModeName: matchedMode.value ?? 'Not set',
                  ),
                ),
              );
            },
            child: _tileWithTextArrow(
              "Type Of Connection",
              ref.watch(loginProvider).data!.first.user?.mode??"Date",
            ),
          ),


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
            _simpleArrowTile("Content And FAQ",(){
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Contactandfaq()),
                        );
            }),
            _simpleArrowTile("Security And Privacy",(){
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Privacysetting()),
                        );
              
            }),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: ()=> _showLogoutDialog(context),
              child: _button("Log Out",DatingColors.primaryGreen,DatingColors.white),),
            const SizedBox(height: 10),
              GestureDetector(
              onTap: () => _showDeleteAccountDialog(context),
              child: _button("Delete Account",  DatingColors.lightGreen, DatingColors.black)
            ),
            const SizedBox(height: 20),
            const Text("Ever Qupid", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Version 6.4.0.0\nCreated With Love.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DatingColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "We'll Be Here If You Need Us Again",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "You Can Use Any Of Your Linked Login Methods To Come Back Anytime",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: DatingColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.g_mobiledata,
                        color: DatingColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Google\nKrish",
                      style: TextStyle(
                        color: DatingColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add new login method functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DatingColors.white.withOpacity(0.2),
                      foregroundColor: DatingColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text("Add New Login Method"),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performLogout(context);
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: DatingColors.errorRed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:DatingColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Ready To Say Good Bye?",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No Problem, But We'd Love To Know Why You're Leaving Us.",
                  style: TextStyle(
                    color: DatingColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _feedbackButton("FOUND SOMEONE", () {
                  // Handle found someone feedback
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("BILLING PROBLEMS", () {
                  // Handle billing problems feedback
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("DIDN'T HAVE A GREAT EXPERIENCE", () {
                  // Handle bad experience feedback
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("OTHER", () {
                  // Handle other feedback
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 12),
                _feedbackButton("CANCEL", () {
                  // Handle other feedback
                  _performDeleteAccount(context);
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _feedbackButton(String text, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(       
            child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
            foregroundColor: DatingColors.white,               
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }

  void _performLogout(BuildContext context) {
    // Close the dialog
    Navigator.of(context).pop();
    
    ref.read(logoutProvider.notifier).logout(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  void _performDeleteAccount(BuildContext context) {
    // Close the dialog
    Navigator.of(context).pop();
    
    // Add your actual delete account logic here
    // For example: delete user data, show confirmation, etc.
    
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deletion initiated')),
    );
  }

  Widget _greenButtonTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DatingColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
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
      tileColor: DatingColors.lightGreen,
      title: Text(title),
      trailing: Text(value),
    );
  }

  Widget _tileWithSwitch(String title, bool value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DatingColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
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
        color: DatingColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(color: DatingColors.mediumGrey)),
        ],
      ),
    );
  }

  Widget _tileWithArrow(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DatingColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DatingColors.primaryGreen),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: DatingColors.primaryGreen,
            child: Icon(Icons.travel_explore, size: 20, color: DatingColors.white),
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
          color: DatingColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DatingColors.darkGreen),
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
        border: Border.all(color: DatingColors.primaryGreen),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
