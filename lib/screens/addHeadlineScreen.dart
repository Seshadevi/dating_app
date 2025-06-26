import 'dart:io';
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
          finalHeadline=args['finalHeadline'] ?? '';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
            color: Colors.black,
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
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Show Everyone\nWhat You’re Made Of",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  "Every Bizz Profile Needs A\nHeadline That Summarizes\nWho You Are, What You Do,\nOr What You’re Looking For.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: screen.width * 0.12,
                  color: const Color.fromARGB(255, 249, 225, 9),
                ),
                SizedBox(height: verticalSpacing),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$userName",
                    style: TextStyle(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screen.height * 0.01),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "I Work At This Company And I\nAm Looking To Connect With\nPeople In Other Industries.",
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
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
                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Add Headline",
                        style: TextStyle(
                          color: Colors.white,
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
                      border: OutlineInputBorder(),
                      labelText: "Enter your headline",
                    ),
                    maxLines: 2,
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
                      backgroundColor: const Color.fromARGB(255, 89, 172, 164),
                      padding: EdgeInsets.symmetric(
                        vertical: screen.height * 0.015,
                        horizontal: screen.width * 0.2,
                      ),
                    ),
                    child: const Text(
                      "Set",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],

                if (finalHeadline != null) ...[
                  SizedBox(height: screen.height * 0.03),
                  Text(
                    "Your headline :\n\n“$finalHeadline”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 7, 159, 124),
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
                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Headline",
                        style: TextStyle(
                          color: Colors.white,
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
                     Navigator.pushNamed(
                          context,
                          '/termsandconditions',
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
                    child: Container(
                      width: screen.width * 0.5,
                      height: screen.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
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
