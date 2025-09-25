import 'dart:io';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
   
   // Add loading state
   bool _isLoading = false;

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
    body: SafeArea(
      child: Stack(
        children: [
          // 🔹 Fullscreen background image
          Positioned.fill(
            child: Image.asset(
              'assets/men_women.jpeg',
              fit: BoxFit.cover, // cover fills entire screen
            ),
          ),

          // 🔹 Main content goes above
          Column(
            children: [
              const Spacer(flex: 9), // push content down a bit
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Stack(
    children: [
      // Background red text (thicker)
      Text(
        'Where Every Swipe Sparks A Story',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6   // thickness of background
            ..color = const Color.fromARGB(255, 160, 43, 41), // 🔴 Red border
        ),
        textAlign: TextAlign.start,
      ),
      // Foreground white text
      const Text(
        'Where Every Swipe Sparks A Story',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.white, // ⚪ White text
        ),
        textAlign: TextAlign.start,
      ),
    ],
  ),
),

              const SizedBox(height: 6),
               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Stack(
    children: [
      // Background red text (thicker)
      Text(
        ' you find new friendships, '
                  'whether you’re new to a city or just looking to expand your social circle.',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w100,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4   // thickness of background
            ..color = const Color.fromARGB(255, 160, 43, 41), // 🔴 Red border
        ),
        textAlign: TextAlign.center,
      ),
      // Foreground white text
      const Text(
        ' you find new friendships, '
                  'whether you’re new to a city or just looking to expand your social circle.',
                   style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w100,
          color: DatingColors.white, // ⚪ White text
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
  onPressed: _isLoading ? null : () async {
    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ref.read(loginProvider.notifier).signupuserApi(
        email: email ?? '',
        mobile: mobile ?? '',
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
        userName: userName ?? '',
        dateOfBirth: dateofbirth ?? '',
        selectedGender: selectedgender ?? '',
        showGenderOnProfile: showonprofile ?? false,
        modeid: modeid,
        modename: modename,
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

      // If your API now returns Map<String, dynamic> with 'status' & 'message'
      final statusCode = result['status'];
      final message = result['message'];

      // Show Snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? "Something went wrong"),
            backgroundColor: (statusCode == 200 || statusCode == 201) 
                ? Colors.green 
                : Colors.red,
          ),
        );
      }

      // Navigate if success
      if ((statusCode == 200 || statusCode == 201) && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomBottomNavigationBar()),
          (route) => false,
        );
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Set loading state to false
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: DatingColors.brown,
    elevation: 0,
  ),
  child: Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [DatingColors.lightpinks, DatingColors.lightpinks],
      ),
      border: Border.all(
        color: DatingColors.everqpidColor,
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Center(
      child: _isLoading 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 160, 43, 41),
              ),
            ),
          )
        : const Text(
            'Got It',
            style: TextStyle(
              color: Color.fromARGB(255, 160, 43, 41),
              fontWeight: FontWeight.bold,
            ),
          ),
    ),
  ),
)

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