import 'package:flutter/material.dart';

// import 'intro_mail.dart';
// import 'intro_partneroption.dart';

class IntroMeetselection extends StatefulWidget {
  const IntroMeetselection({super.key});

  @override
  State<IntroMeetselection> createState() => IntroMeetselectionState();
}

class IntroMeetselectionState extends State<IntroMeetselection> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedGender;
  bool isOpenToEveryone = false; // Added toggle state

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                // Text(
                //   "who would you like to meet?",
                //   style: TextStyle(
                //     fontFamily: 'Inter',
                //     fontSize: 30.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: screenHeight * 0.025),
                Text(
                  "you can choose more than one answer and change it any time.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
                // SizedBox(height: screenHeight * 0.04),

                // Toggle switch for "I'm open to dating everyone"
                _buildToggleOption(),
                // SizedBox(height: screenHeight * 0.025),

                // Gender Radio Buttons
                _buildGenderOption("Woman", Color(0xffE9F1C4)),
                SizedBox(height: screenHeight * 0.025),
                _buildGenderOption("Man", Color(0xffE9F1C4)),
                SizedBox(height: screenHeight * 0.025),
                _buildGenderOption("Nonbinary", Color(0xffE9F1C4)),

                // Bottom note
                SizedBox(height: screenHeight * 0.075),

                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "You'll Only Be Shown To People In The \nSame Mode As You.",
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
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
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         InrtoPartneroption()));
                //           },
                //           icon: Icon(Icons.arrow_forward_ios)),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New toggle widget for "I'm open to dating everyone"
  Widget _buildToggleOption() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Switch(
            value: isOpenToEveryone,
            onChanged: (value) {
              setState(() {
                isOpenToEveryone = value;
                // If open to everyone, clear specific gender selection
                if (value) {
                  selectedGender = null;
                }
              });
            },
            activeTrackColor: Color(0xffB2D12E),
            activeColor: Colors.white,
            inactiveTrackColor: Color(0xFFD3D3D3),
            inactiveThumbColor: Colors.white,
          ),
          Text(
            "i'm open to dating everyone",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 60, 60, 60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, Color defaultBackgroundColor) {
    bool isSelected = selectedGender == gender;

    // Text color changes to white when selected
    Color textColor =
        isSelected ? Colors.white : Color.fromARGB(255, 90, 118, 81);

    return InkWell(
      onTap: () {
        // Only allow selection if not open to everyone
        if (!isOpenToEveryone) {
          setState(() {
            selectedGender = gender;
          });
        }
      },
      child: Opacity(
        // Make options look disabled when "open to everyone" is selected
        opacity: isOpenToEveryone ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              color:
                  isSelected ? const Color(0xff92AB26) : defaultBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  width: 2,
                  color: isSelected ? Color(0xffE9F1C4) : Colors.transparent)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gender,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
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
          ),
        ),
      ),
    );
  }
}
