import 'dart:io';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/beKindScreen.dart';
import 'package:flutter/material.dart';

class AddHeadlineScreen extends StatefulWidget {

  const AddHeadlineScreen({super.key});

  @override
  State<AddHeadlineScreen> createState() => _AddHeadlineScreenState();
}

class _AddHeadlineScreenState extends State<AddHeadlineScreen> {
  bool showHeadlineInput = false;
  final TextEditingController _headlineController = TextEditingController();
   String? finalHeadline;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { 

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
          selectedheight=args['selectedheight'] ?? 154 ;
          selectedinterestsIds=args['selectedinterestIds'] ?? [];
          selectedQualitiesIds=args['selectedQualitiesIds'] ?? [];
          selectedHabitIds=args['selectedHabbits'] ?? [];
          selectedKidsIds=args['selectedKidsIds'] ?? [];
          selectedReligionIds= args['selectedReligionIds'] ?? [];
          selectedcausesIds = args['selectedCausesIds'] ?? [];
          seletedprompts = args['selectedPrompts'] ?? {};
          selectedIndexes=args['selectedmessagesIds'] ?? [];
           selectedImages = (args['selectedImages'] as List<File?>?) ?? List.filled(6, null);
           if (args['finalHeadline'] != null && args['finalHeadline'].toString().isNotEmpty) {
            finalHeadline = args['finalHeadline'];
          }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final padding = screen.width * 0.05;
    final titleFontSize = screen.width * 0.06;
    final subtitleFontSize = screen.width * 0.038;
    final labelFontSize = screen.width * 0.05;
    final bodyFontSize = screen.width * 0.036;
    final verticalSpacing = screen.height * 0.02;

    return Scaffold(
      backgroundColor: DatingColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: DatingColors.backgroundWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: DatingColors.black),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
               Navigator.pushNamed(
                context,
                '/photosScreen',
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
                  'email':email,
                  'mobile':mobile
                },);
          },
        ),
        title: Text(
          'Ever Qupid',
          style: TextStyle(
            color: DatingColors.black,
            fontWeight: FontWeight.bold,
            fontSize: screen.width * 0.045,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: DatingColors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Impression Matters Make It Count",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                // Text(
                //   "Every Bizz Profile Needs A\nHeadline That Summarizes\nWho You Are, What You Do,\nOr What You’re Looking For.",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: subtitleFontSize,
                //     height: 1.5,
                //     color: Colors.black87,
                //   ),
                // ),
                // SizedBox(height: verticalSpacing),
                // Icon(
                //   Icons.keyboard_arrow_down_rounded,
                //   size: screen.width * 0.12,
                //   color: DatingColors.yellow,
                // ),
                SizedBox(height: verticalSpacing),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "$userName",
                //     style: TextStyle(
                //       fontSize: labelFontSize,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // SizedBox(height: screen.height * 0.01),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "I Work At This Company And I\nAm Looking To Connect With\nPeople In Other Industries.",
                //     style: TextStyle(
                //       fontSize: bodyFontSize,
                //       height: 1.5,
                //       color: Colors.black87,
                //     ),
                //   ),
                // ),
                SizedBox(height: screen.height * 0.04),

                if (finalHeadline == null) ...[
                  // FULL WIDTH "Add Headline" before anything is set
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showHeadlineInput = true;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: screen.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Add Headline",
                        style: TextStyle(
                          color:DatingColors.brown,
                          fontSize: screen.width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                if (showHeadlineInput) ...[
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _headlineController,
                    decoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: "Enter your headline",
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: screen.height * 0.015),
                  ElevatedButton(
                    onPressed: () {
                      if (_headlineController.text.trim().isNotEmpty) {
                        setState(() {
                          finalHeadline = _headlineController.text.trim();
                          showHeadlineInput = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DatingColors.lightpinks,
                      padding: EdgeInsets.symmetric(
                        vertical: screen.height * 0.015,
                        horizontal: screen.width * 0.2,
                      ),
                    ),
                    child: const Text(
                      "Set",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ],

                if (finalHeadline != null) ...[
                  SizedBox(height: screen.height * 0.03),
                  RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Your headline :\n\n",
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontStyle: FontStyle.italic,
                                color: DatingColors.accentTeal, // color for "Your headline :"
                              ),
                            ),
                            TextSpan(
                              text: "“$finalHeadline”",
                              style: TextStyle(
                                fontSize: bodyFontSize,
                                fontStyle: FontStyle.italic,
                                color: DatingColors.brown, // color for the headline
                              ),
                            ),
                          ],
                        ),
                      ),

                  SizedBox(height: screen.height * 0.025),

                  // Edit Headline Button (half width)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showHeadlineInput = true;
                      });
                    },
                    child: Container(
                      width: screen.width * 0.5,
                      height: screen.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DatingColors.primaryGreen,DatingColors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Headline",
                        style: TextStyle(
                          color: DatingColors.white,
                          fontSize: screen.width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screen.height * 0.025),

                  // NEXT Button (same green style)
                  GestureDetector(
                    onTap: () {
                    //  Navigator.pushNamed(
                    //       context,
                    //       '/termsandconditions',
                    //       arguments: {
                    //         'latitude': latitude,
                    //         'longitude': longitude,
                    //         'dateofbirth':dateofbirth,
                    //         'userName':userName,
                    //         'selectgender':selectedgender,
                    //         "showonprofile":showonprofile,
                    //         "modeid":modeid,
                    //         "modename":modename,
                    //         "selectedGenderIds":selectedGenderIds,
                    //         "selectedoptionIds":selectedoptionIds,
                    //         "selectedheight":selectedheight,
                    //         "selectedinterestIds":selectedinterestsIds,
                    //         "selectedQualitiesIds":selectedQualitiesIds,
                    //         "selectedHabbits":selectedHabitIds,
                    //         "selectedKidsIds":selectedKidsIds,
                    //         "selectedReligionIds":selectedReligionIds,
                    //         "selectedCausesIds":selectedcausesIds,
                    //         "selectedPrompts":seletedprompts,
                    //         "selectedmessagesIds":selectedIndexes,
                    //         "selectedImages":selectedImages,
                    //         "finalHeadline":finalHeadline,
                    //         'email':email,
                    //         'mobile':mobile
                    //       },);
                    print("latitude:$latitude");
                    print("longitude:$longitude");
                    print("username:$userName");
                    print("dob:$dateofbirth");

                    print("gender:$selectedgender");
                    print("email:$email");
                    print("mobile:$mobile");
                    print("modeid:$modeid");
                    print("choose for date:$selectedGenderIds");
                    print("looking for:$selectedoptionIds");
                    print("height:$selectedheight");
                    print("messages:$selectedIndexes");
                    print("images:$selectedImages");
                    print("headline:$finalHeadline");
                        
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
                              // "termsAndCondition":termsAndCondition,
                              'email':email,
                              'mobile':mobile
                            },);
                     },
                    child: Container(
                      width: screen.width * 0.5,
                      height: screen.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DatingColors.primaryGreen, DatingColors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: DatingColors.white,
                          fontSize: screen.width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
