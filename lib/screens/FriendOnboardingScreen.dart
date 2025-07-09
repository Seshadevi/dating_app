import 'dart:io';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/tab_bar/tabScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/glitchScreen.dart';

class FriendOnboardingScreen extends ConsumerStatefulWidget {
  
  const FriendOnboardingScreen({super.key});

  @override
  ConsumerState<FriendOnboardingScreen> createState() => _FriendOnboardingScreenState();
}


class _FriendOnboardingScreenState extends ConsumerState<FriendOnboardingScreen> {

   String? email;
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String? selectedgender;
   bool? showonprofile;
   int? modeid;
   String? modename;
   List<String>? selectedGenderIds;
   List<int>? selectedoptionIds;
   int? selectedheight;
   List<int>? selectedinterestsIds;
   List<int>? selectedQualitiesIds;
   List<int>? selectedHabitIds;
   List<int>? selectedKidsIds;
   List<int>? selectedReligionIds;
   List<int>? selectedcausesIds;
   Map<int, String>? seletedprompts;
   List<int>? selectedIndexes;
   List<File?>? selectedImages;
   String? finalHeadline;
   bool? termsAndCondition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0;
          longitude = args['longitude'] ?? 0.0;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? true;
          modeid=args['modeid'] ?? 0;
          modename =args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedoptionIds=args['selectedoptionIds'] ?? [];
          selectedheight=args['selectedheight'] ?? 154;
          selectedinterestsIds=args['selectedinterestIds'] ?? [];
          selectedQualitiesIds=args['selectedQualitiesIds'] ?? [];
          selectedHabitIds=args['selectedHabbits'] ?? [];
          selectedKidsIds=args['selectedKidsIds'] ?? [];
          selectedReligionIds= args['selectedReligionIds'] ?? [];
          selectedcausesIds = args['selectedCausesIds'] ?? [];
          seletedprompts = args['selectedPrompts'] ?? {};
          selectedIndexes=args['selectedmessagesIds'] ?? [];
           selectedImages = (args['selectedImages'] as List<File?>?) ?? List.filled(6, null);
          finalHeadline=args['finalHeadline'] ?? '';
          termsAndCondition=args['termsAndCondition'] ?? false;
      });
    }
  }

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
                      onPressed: () async {
                      final statuscode = await ref.read(loginProvider.notifier).signupuserApi(
                        email: email ?? '',
                        mobile:mobile ??'',
                        latitude: latitude ?? 0.0,
                        longitude: longitude ?? 0.0,
                        userName: userName ?? '',
                        dateOfBirth: dateofbirth ?? '',
                        selectedGender: selectedgender ?? '',
                        showGenderOnProfile: showonprofile ?? false,
                        modeid:modeid,
                        modename:modename,
                        selectedGenderIds: selectedGenderIds ?? [],
                        selectionOptionIds: selectedoptionIds ?? [],
                        selectedHeight: selectedheight ?? 0,
                        selectedInterestIds: selectedinterestsIds ?? [],
                        selectedqualitiesIDs: selectedQualitiesIds ?? [],
                        selectedhabbits: selectedHabitIds ?? [],
                        selectedkids: selectedKidsIds ?? [],
                        selectedreligions: selectedReligionIds ?? [],
                        selectedcauses: selectedcausesIds ?? [],
                        seletedprompts: seletedprompts ?? {},
                        choosedimages: selectedImages ?? [],
                        defaultmessages: selectedIndexes ?? [],
                        finalheadline: finalHeadline,
                        termsAndCondition: termsAndCondition ?? false,
                      );

                      if (statuscode == 200 || statuscode == 201) {
                          // After successful signup/login:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => CustomBottomNavigationBar()),
                            (route) => false, // remove all previous screens
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
