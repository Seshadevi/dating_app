import 'package:flutter/material.dart';

// import 'Intro_heightselection.dart';

class InrtoPartneroption extends StatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final showMode;
  final String? gendermode;
  const InrtoPartneroption(
      {super.key,
      required this.email,
      required this.latitude,
      required this.longitude,
      required this.userName,
      required this.dateOfBirth,
      required this.selectedGender,
      required this.showGenderOnProfile,
      this.showMode,
       this.gendermode});

  @override
  State createState() => InrtoPartneroptionState();
}

class InrtoPartneroptionState extends State {
  final List options = [
    'A Long-Term Relationship',
    'A Life Partner',
    'Fun,Casual Dates',
    'Intimacy, Without Commitment',
    'Marriage',
    'Ethical Non-Monogamy',
  ];

  final Set selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return
        // Scaffold(
        //   backgroundColor: Colors.white,
        //   body:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: screenHeight * 0.04),

        // Title section with heart image - full width, no padding
        Container(
          height: screenHeight * 0.2,
          width: screenWidth,
          child: Stack(
            //clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: 0,
                child: Image.asset(
                  'assets/Heart.png',
                  height: 175,
                  width: 175,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'And What Are You\nHoping To Find?',
                    //   style: TextStyle(
                    //     fontSize: 32,
                    //     fontWeight: FontWeight.bold,
                    //     height: 1.2,
                    //     letterSpacing: 1,
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    Text(
                      textAlign: TextAlign.center,
                      'It\'s Your Dating Journey, So\nChoose 1 Or 2 Options That Feel\nRight For You.',
                      style: TextStyle(
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.04),

        // Options list with padding
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedOptions.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedOptions.remove(index);
                        } else {
                          // Ensure we don't exceed 2 selections
                          if (selectedOptions.length < 2) {
                            selectedOptions.add(index);
                          }
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          options[index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color:
                                isSelected ? Color(0xff92AB26) : Colors.black87,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Color(0xff92AB26)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xff92AB26)
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Footer with eye icon (with padding)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 24,
                color: Colors.grey[600],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This Will Show On Your Profile To Help Everyone Find What They\'re Looking For.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Bottom counter and next button (with padding)
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedOptions.length}/2 Selected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Container(
              //   width: 56,
              //   height: 56,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         Color(0xffB2D12E),
              //         Color(0xff000000),
              //       ],
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //     ),
              //     shape: BoxShape.circle,
              //   ),
              //   child: IconButton(
              //       icon: Icon(
              //         Icons.arrow_forward,
              //         color: Colors.white,
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => HeightSelectionScreen()));
              //       }),
              // ),
            ],
          ),
        ),
      ],
      // ),
    );
  }
}
