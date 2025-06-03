// import 'package:dating/pages/intro_meetselection.dart';
import 'package:flutter/material.dart';

// import 'intro_mail.dart';

class IntroDatecategory extends StatefulWidget {
  const IntroDatecategory({super.key});

  @override
  State<IntroDatecategory> createState() => IntroDatecategoryState();
}

class IntroDatecategoryState extends State<IntroDatecategory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return 
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: screenHeight * 0.05),
                  // Text(
                  //   "What Brings You To \nHeartSync?",
                  //   style: TextStyle(
                  //     fontFamily: 'Inter',
                  //     fontSize: 30.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: screenHeight * 0.025),
                  Text(
                    "Romance And Butterflies Or A Beautiful Friendship? Choose A Mode To Find Your People.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      height: 1.3,
                    ),
                  ),
                  // SizedBox(height: screenHeight * 0.04),
                  // Gender Radio Buttons
                  _buildGenderOption("Date", Color(0xffE9F1C4),
                      "find a relationship, something casual , oranything in - between"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildGenderOption("BFF", Color(0xffE9F1C4),
                      "make new friends and find your community"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildGenderOption("Bizz", Color(0xffE9F1C4),
                      "network professionally and make career moves"),

                  // Bottom note
                  // SizedBox(height: screenHeight * 0.05),

                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "You’ll Only Be Shown To People In The \nSame Mode As You.",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.4,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //       width: screenWidth * 0.125,
                  //       height: screenWidth * 0.125,
                  //       decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //             colors: [
                  //               Color(0xffB2D12E),
                  //               Color(0xff000000),
                  //             ],
                  //             stops: [0.0, 1.0],
                  //             begin: AlignmentDirectional(0.0, -1.0),
                  //             end: AlignmentDirectional(0, 1.0),
                  //           ),
                  //           borderRadius: BorderRadius.circular(50)),
                  //       child: IconButton(
                  //           color: Colors.white,
                  //           onPressed: () {
                  //             // Navigator.push(
                  //             //     context,
                  //             //     MaterialPageRoute(
                  //             //         builder: (context) =>
                  //             //             IntroMeetselection()));
                  //           },
                  //           icon: Icon(Icons.arrow_forward_ios)),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        // ),
      // ),
    );
  }

  Widget _buildGenderOption(
      String gender, Color defaultBackgroundColor, String category) {
    bool isSelected = selectedGender == gender;

    // Text color changes to white when selected
    Color textColor =
        isSelected ? Colors.white : Color.fromARGB(255, 90, 118, 81);

    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xff92AB26) : defaultBackgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                width: 2,
                color: isSelected ? Color(0xffE9F1C4) : Colors.transparent)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gender,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Color.fromARGB(255, 90, 118, 81),
                          width: 2,
                        ),
                        color: isSelected
                            ? Color.fromARGB(255, 90, 118, 81)
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
