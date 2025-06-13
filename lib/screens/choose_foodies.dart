import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<String> selectedInterests = ['Museums & Galleries'];

  final List<String> allInterests = [
    'Tennis +', 'Gigs +', 'Dogs +', 'Craft +', 'Hicking Trips +', 'writing +',
    'photography +', 'museums & galleries +', 'cat +', 'horror +', 'flexible +',
    'caring +', 'reading +', 'fitness +', 'Gardening +', 'language +'
  ];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return 
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child:
         Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screen.width * 0.05,
            vertical: screen.height * 0.015,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Icon(Icons.arrow_back, color: Colors.black),
                    //     SizedBox(width: 8),
                    //     Text(
                    //       'Back',
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: screen.height * 0.02),
                    Text(
                      'Proud foodie or big on\nbouldering? Add interests to your profile to help you match with people who love them too.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: screen.width * 0.04,
                      ),
                    ),
                    SizedBox(height: screen.height * 0.025),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screen.width * 0.04),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF0D1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you into?',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screen.height * 0.015),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedInterests.map((interest) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF496700),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )).toList(),
                    ),
                    SizedBox(height: screen.height * 0.02),
                    Text(
                      'You Might Like',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: screen.height * 0.6,
                      child: Stack(
                        children: List.generate(allInterests.length, (index) {
                          final interest = allInterests[index];
                          final isSelected = selectedInterests.contains(interest);

                          final positions = [
                            Offset(20, 10), Offset(130, 0), Offset(240, 20), Offset(50, 110), Offset(160, 100),
                            Offset(20, 200), Offset(130, 190), Offset(240, 210), Offset(60, 290), Offset(170, 280),
                            Offset(20, 370), Offset(130, 360), Offset(240, 370), Offset(50, 450), Offset(160, 460),
                            Offset(90, 540)
                          ];

                          final Offset pos = index < positions.length ? positions[index] : Offset(0, index * 60);

                          return Positioned(
                            top: pos.dy,
                            left: pos.dx,
                            child: GestureDetector(
                              onTap: () => toggleInterest(interest),
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : LinearGradient(
                                          colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  interest,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: screen.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${selectedInterests.length}/5 Selected',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        // ),
      // ),
    );
  }
}
