import 'dart:io';

import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/FriendOnboardingScreen.dart';
import 'package:flutter/material.dart';

class BeKindScreen extends StatefulWidget {
  
  
  const BeKindScreen({super.key,});

  @override
  State<BeKindScreen> createState() => _BeKindScreenState();
}

class _BeKindScreenState extends State<BeKindScreen> {
  bool showTerms = false;
  bool isChecked = false;
  
  

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
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double padding = screen.width * 0.05;
    final double titleFontSize = screen.width * 0.055;
    final double bodyFontSize = screen.width * 0.037;
    final double buttonFontSize = screen.width * 0.043;
    final double checkboxFontSize = screen.width * 0.036;

    bool termsAndCondition = isChecked;

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        title: Text(
          'Ever Qupid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DatingColors.black,
            fontSize: screen.width * 0.045,
          ),
        ),
        backgroundColor: DatingColors.white,
        iconTheme: const IconThemeData(color:DatingColors.black),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
             Navigator.pushNamed(
                context,
                '/addheadlinescreen',
                arguments: {
                  'latitude': latitude,
                  'longitude': longitude,
                  'dateofbirth':dateofbirth,
                  'userName':userName,
                  'selectgender':selectedgender,
                  "showonprofile":showonprofile,
                  "modeid":modeid,
                  "modename":modename,
                  "selectedGenderIds":selectedGenderIds,
                  "selectedoptionIds":selectedoptionIds,
                  "selectedheight":selectedheight,
                  "selectedinterestIds":selectedinterestsIds,
                  "selectedQualitiesIds":selectedQualitiesIds,
                  "selectedHabbits":selectedHabitIds,
                  "selectedKidsIds":selectedKidsIds,
                  "selectedReligionIds":selectedReligionIds,
                  "selectedCausesIds":selectedcausesIds,
                  "selectedPrompts":seletedprompts,
                  "selectedmessagesIds":selectedIndexes,
                  "selectedImages":selectedImages,
                  "finalHeadline":finalHeadline,
                  'email':email,
                  'mobile':mobile
                },);
             },
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screen.height * 0.015),
                CircleAvatar(
                  radius: screen.width * 0.25,
                  backgroundImage: const AssetImage('assets/acceptImage.png'),
                ),
                SizedBox(height: screen.height * 0.025),
                Text(
                  "It’s Cool To Be Kind",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: screen.height * 0.02),
                Text(
                  "We're All About Equality In Relationships. Here, We Hold People Accountable For The Way They Treat Each Other.\n\n"
                  "We Ask Everyone On Heart Sync To Be Kind And Respectful, So Every Person Can Have A Great Experience.\n\n"
                  "By Using Heart Sync, You’re Agreeing To Adhere To Our Values As Well As Our ",
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTerms = !showTerms;
                    });
                  },
                  child: Text(
                    "Guidelines.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: DatingColors.accentTeal,
                      fontSize: bodyFontSize,
                    ),
                  ),
                ),

                if (showTerms) ...[
                  SizedBox(height: screen.height * 0.02),
                  Text(
                    "Please read and accept the following terms before continuing:",
                    style: TextStyle(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: screen.height * 0.015),
                  Container(
                    padding: EdgeInsets.all(screen.width * 0.04),
                    decoration: BoxDecoration(
                      color: DatingColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "• Treat everyone with kindness and respect.\n"
                      "• Avoid hate speech, harassment, or discrimination.\n"
                      "• Follow community guidelines and be honest.\n"
                      "• Violations may lead to account suspension or removal.",
                      style: TextStyle(fontSize: bodyFontSize, height: 1.5),
                    ),
                  ),
                  SizedBox(height: screen.height * 0.015),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I have read and agree to the terms and conditions.",
                          style: TextStyle(fontSize: checkboxFontSize),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: screen.height * 0.05),

                // I Accept Button
                GestureDetector(
                  onTap: isChecked
                      ? () {
                           Navigator.pushNamed(
                            context,
                            '/finalStageSingupScreen',
                            arguments: {
                              'latitude': latitude,
                              'longitude': longitude,
                              'dateofbirth':dateofbirth,
                              'userName':userName,
                              'selectgender':selectedgender,
                              "showonprofile":showonprofile,
                              "modeid":modeid,
                              "modename":modename,
                              "selectedGenderIds":selectedGenderIds,
                              "selectedoptionIds":selectedoptionIds,
                              "selectedheight":selectedheight,
                              "selectedinterestIds":selectedinterestsIds,
                              "selectedQualitiesIds":selectedQualitiesIds,
                              "selectedHabbits":selectedHabitIds,
                              "selectedKidsIds":selectedKidsIds,
                              "selectedReligionIds":selectedReligionIds,
                              "selectedCausesIds":selectedcausesIds,
                              "selectedPrompts":seletedprompts,
                              "selectedmessagesIds":selectedIndexes,
                              "selectedImages":selectedImages,
                              "finalHeadline":finalHeadline,
                              "termsAndCondition":termsAndCondition,
                              'email':email,
                              'mobile':mobile
                            },);
                        }
                      : null,
                  child: Opacity(
                    opacity: isChecked ? 1.0 : 0.4,
                    child: Container(
                      width: double.infinity,
                      height: screen.height * 0.065,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DatingColors.primaryGreen,DatingColors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "I Accept",
                        style: TextStyle(
                          color: DatingColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screen.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
