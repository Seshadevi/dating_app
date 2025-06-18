import 'dart:io';

import 'package:dating/screens/beKindScreen.dart';
import 'package:flutter/material.dart';

class AddHeadlineScreen extends StatefulWidget {

  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final dynamic showMode;
  final String? gendermode;
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

  const AddHeadlineScreen({super.key,required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    this.gendermode,
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
    required this.defaultmessages});

  @override
  State<AddHeadlineScreen> createState() => _AddHeadlineScreenState();
}

class _AddHeadlineScreenState extends State<AddHeadlineScreen> {
  bool showHeadlineInput = false;
  final TextEditingController _headlineController = TextEditingController();
  String? finalHeadline;

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
                    "Sai",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BeKindScreen(
                                                email: widget.email,
                                                latitude: widget.latitude,
                                                longitude: widget.longitude,
                                                userName: widget.userName,
                                                dateOfBirth: widget.dateOfBirth,
                                                selectedGender: widget.selectedGender,
                                                showGenderOnProfile: widget.showGenderOnProfile,
                                                showMode: widget.showMode,
                                                gendermode:widget.gendermode,
                                                selectionOptionIds:widget.selectionOptionIds,
                                                selectedHeight:widget.selectedHeight ,
                                                selectedInterestIds:widget.selectedInterestIds,
                                                selectedqualitiesIDs:widget.selectedqualitiesIDs,
                                                selectedhabbits: widget.selectedhabbits,
                                                selectedkids:widget.selectedkids,
                                                selectedreligions:widget.selectedreligions,
                                                selectedcauses:widget.selectedcauses,
                                                seletedprompts:widget.seletedprompts,
                                                choosedimages:widget.choosedimages,
                                                defaultmessages:widget.defaultmessages,
                                                finalheadline:finalHeadline
                          ),
                        ),
                      );
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
