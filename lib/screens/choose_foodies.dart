import 'package:dating/screens/valueSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final showMode;
  final String? gendermode;
 
  final dynamic selectedHeight;
  final dynamic selectionOptionIds;
   
  

  const InterestsScreen( {
    Key? key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    this.gendermode,
   required this.selectedHeight,
   this.selectionOptionIds,
     
  }) : super(key: key);

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  List<String> selectedInterests = ['Museums & Galleries'];

  final List<String> allInterests = [
    'Tennis +',
    'Gigs +',
    'Dogs +',
    'Craft +',
    'Hicking Trips +',
    'writing +',
    'photography +',
    'museums & galleries +',
    'cat +',
    'horror +',
    'flexible +',
    'caring +',
    'reading +',
    'fitness +',
    'Gardening +',
    'language +'
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
    final screenWidth = screen.width;
    final screenHeight = screen.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screen.width * 0.05,
                  vertical: screen.height * 0.010,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 15),
                   Row(
                     children: [
                     IconButton(
                              icon: const Icon(Icons.arrow_back_ios,),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 230),
                            GestureDetector(
                    onTap: () {
                      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ValuesSelectionScreen(
                    email: widget.email,
                                          latitude: widget.latitude,
                                          longitude: widget.longitude,
                                          userName: widget.userName,
                                          dateOfBirth: widget.dateOfBirth,
                                          selectedGender: widget.selectedGender,
                                          showGenderOnProfile: widget.showGenderOnProfile,
                                          showMode: widget.showMode,
                                          gendermode: widget.gendermode,
                                          selectedHeight: widget.selectedHeight,
                                          selectionOptionIds:widget.selectionOptionIds,
                                          selectedIntersts: selectedInterests,
                  )),
                );

                                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                     ]

                   ),
                    
                    // const SizedBox(height: 15),
                    
                      LinearProgressIndicator(
                        value: 7 / 16,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 147, 179, 3),
                        ),
                      ),
                    const SizedBox(height: 15),
                       Row(
                        children: [
                          
                          const SizedBox(width: 5),
                          const Text(
                            "Choose Five Things\nYou Are Really Into",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    
                    SizedBox(height: screen.height * 0.02),
                    Text(
                      'Proud foodie or big on bouldering?\n Add interests to your profile to help you match with people who love them too.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: screen.width * 0.04,
                      ),
                    ),
                    SizedBox(height: screen.height * 0.025),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screen.width * 0.04),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF0D1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you into?',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: screen.height * 0.015),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedInterests
                          .map((interest) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF496700),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    interest,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList(),
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
                          final isSelected =
                              selectedInterests.contains(interest);

                          final positions = [
                            const Offset(20, 10),
                            const Offset(130, 0),
                            const Offset(240, 20),
                            const Offset(50, 110),
                            const Offset(160, 100),
                            const Offset(20, 200),
                            const Offset(130, 190),
                            const Offset(240, 210),
                            const Offset(60, 290),
                            const Offset(170, 280),
                            const Offset(20, 370),
                            const Offset(130, 360),
                            const Offset(240, 370),
                            const Offset(50, 450),
                            const Offset(160, 460),
                            const Offset(90, 540)
                          ];

                          final Offset pos = index < positions.length
                              ? positions[index]
                              : Offset(0, index * 60);

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
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF869E23),
                                            Color(0xFF000000)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            Color(0xFFF3F7DA),
                                            Color(0xFFE6EBA4)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  boxShadow: const [
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
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: screenWidth * 0.125,
                              height: screenWidth * 0.125,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xffB2D12E), Color(0xff000000)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                                onPressed: () {
                                  if (selectedInterests.isNotEmpty) {
                                    print("✅ Proceeding with:");
                                    print("Email: ${widget.email}");
                                    print("Lat: ${widget.latitude}, Long: ${widget.longitude}");
                                    print("Username: ${widget.userName}");
                                    print("DOB: ${widget.dateOfBirth}");
                                    print("Gender: ${widget.selectedGender}");
                                    print("Show Gender: ${widget.showGenderOnProfile}");
                                    print("Selected Mode: ${widget.showMode?.value} (ID: ${widget.showMode?.id})");
                                    print("Selected Looking For: ${widget.gendermode}");
                                    print("Selected Interests: $selectedInterests");

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ValuesSelectionScreen(
                                          email: widget.email,
                                          latitude: widget.latitude,
                                          longitude: widget.longitude,
                                          userName: widget.userName,
                                          dateOfBirth: widget.dateOfBirth,
                                          selectedGender: widget.selectedGender,
                                          showGenderOnProfile: widget.showGenderOnProfile,
                                          showMode: widget.showMode,
                                          gendermode: widget.gendermode,
                                          selectedHeight: widget.selectedHeight,
                                          selectionOptionIds:widget.selectionOptionIds,
                                          selectedIntersts: selectedInterests,
                                          
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Please select at least one interest")),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
