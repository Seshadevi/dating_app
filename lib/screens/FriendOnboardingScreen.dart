import 'dart:io';

import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/tab_bar/tabScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/glitchScreen.dart';

class FriendOnboardingScreen extends ConsumerStatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final dynamic showMode;
  final List<String> selectedGenderIds;
  final List<int> selectionOptionIds;
  final dynamic selectedHeight;
  final List<int> selectedInterestIds;
  final List<int> selectedqualitiesIDs;
  final List<int> selectedhabbits;
  final List<int> selectedkids;
  final List<int> selectedreligions;
  final List<int> selectedcauses;
  final List<String> seletedprompts;
  final List<File?> choosedimages;
  final List<int> defaultmessages;
  final String? finalheadline;
  final bool termsAndCondition;
  const FriendOnboardingScreen({
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    required this.selectedGenderIds,
    required this.selectionOptionIds,
    this.selectedHeight,
    required this.selectedInterestIds,
    required this.selectedqualitiesIDs,
    required this.selectedhabbits,
    required this.selectedkids,
    required this.selectedreligions,
    required this.selectedcauses,
    required this.seletedprompts,
    required this.choosedimages,
    required this.defaultmessages,
    required this.finalheadline, 
    required this.termsAndCondition});

  @override
  ConsumerState<FriendOnboardingScreen> createState() => _FriendOnboardingScreenState();
}

class _FriendOnboardingScreenState extends ConsumerState<FriendOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 90,
              left: -10, // Adjust this to move it to the left
              child: SizedBox(
                height: 280,
                child: Image.asset(
                  'assets/womenback.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Positioned image
            Stack(
              children: [
                Positioned(
                  top: 10,
                  left: -10,
                  child: SizedBox(
                    height: 350,
                    child: Image.asset(
                      'assets/women.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            // Main content
            Column(
              children: [
                const SizedBox(height: 400), // Adjust based on image height
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Make New Friends At Every Stage Of Your Life',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'BFF will help you find new friendships, whether you’re new to a city or just looking to expand your social circle.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async{
                        final statuscode = await ref.read(loginProvider.notifier).signupuserApi(
                              email: widget.email,
                              latitude: widget.latitude,
                              longitude: widget.longitude,
                              userName: widget.userName,
                              dateOfBirth: widget.dateOfBirth,
                              selectedGender: widget.selectedGender,
                              showGenderOnProfile: widget.showGenderOnProfile,
                              showMode: widget.showMode,
                              selectedGenderIds: widget.selectedGenderIds,
                              selectionOptionIds: widget.selectionOptionIds,
                              selectedHeight: widget.selectedHeight,
                              selectedInterestIds: widget.selectedInterestIds,
                              selectedqualitiesIDs: widget.selectedqualitiesIDs,
                              selectedhabbits: widget.selectedhabbits,
                              selectedkids: widget.selectedkids,
                              selectedreligions: widget.selectedreligions,
                              selectedcauses: widget.selectedcauses,
                              seletedprompts: widget.seletedprompts,
                              choosedimages: widget.choosedimages,
                              defaultmessages: widget.defaultmessages,
                              finalheadline: widget.finalheadline,
                              termsAndCondition: widget.termsAndCondition,
                            );

                        if(statuscode==200 ||statuscode==201){
                           Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB6D96E), Color(0xFF000000)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Text(
                            'Got It',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
