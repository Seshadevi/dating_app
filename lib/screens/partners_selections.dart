

import 'package:dating/provider/signupprocessProviders/lookingProvider.dart';
import 'package:dating/screens/height_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'Intro_heightselection.dart';

class InrtoPartneroption extends ConsumerStatefulWidget {
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
       this.gendermode
    });

  @override
  ConsumerState<InrtoPartneroption> createState() => InrtoPartneroptionState();
}

class InrtoPartneroptionState extends ConsumerState<InrtoPartneroption> {

  @override
  void initState() {
    super.initState();
    ref.read(lookingProvider.notifier).getLookingFor();
  }

  final List options = [
    'A Long-Term Relationship',
    'A Life Partner',
    'Fun,Casual Dates',
    'Intimacy, Without Commitment',
    'Marriage',
    'Ethical Non-Monogamy',
  ];

  final Set<int> selectedOptionIds = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final lookingData = ref.watch(lookingProvider).data ?? [];

    return 
    Scaffold(
      backgroundColor: Colors.white,
      body:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: 7 / 16,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 147, 179, 3)),
                ),
              ),
              const SizedBox(height: 15),
              // Back button and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "And What Are You\nHoping To Find?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: screenHeight * 0.020),
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
                        textAlign: TextAlign.start,
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

          SizedBox(height: screenHeight * 0.015),

          // Options list with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: lookingData.isEmpty
                ? Center(child: CircularProgressIndicator())
                :ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: lookingData.length,
                itemBuilder: (context, index) {
                  final item = lookingData[index];
                final isSelected = selectedOptionIds.contains(item.id);


                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: GestureDetector(
                       onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedOptionIds.remove(item.id);
                            } else {
                              if (selectedOptionIds.length < 2) {
                                selectedOptionIds.add(item.id!);
                              }
                            }
                          });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                             item.value ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? Color(0xff92AB26)
                                  : Colors.black87,
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
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedOptionIds.length}/2 Selected',
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
           Align(
            alignment: Alignment.bottomRight,
            child: Padding(
               padding: const EdgeInsets.only(right: 24, bottom: 24),
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
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      if (selectedOptionIds.length < 3) {
                        print("✅ Proceeding with:");
                        print("Email: ${widget.email}");
                        print("Lat: ${widget.latitude}, Long: ${widget.longitude}");
                        print("Username: ${widget.userName}");
                        print("DOB: ${widget.dateOfBirth}");
                        print("Gender: ${widget.selectedGender}");
                        print("Show Gender: ${widget.showGenderOnProfile}");
                        print("Selected Mode: ${widget.showMode.value} (ID: ${widget.showMode.id})");
                        print("Selected options: $selectedOptionIds");
                        print("email............${widget.email}");
                    
                    //     // Navigator.push(...) your next screen here
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> HeightSelectionScreen(
                                    email: widget.email,
                                    latitude: widget.latitude,
                                    longitude: widget.longitude,
                                    userName: widget.userName,
                                    dateOfBirth: widget.dateOfBirth,
                                    selectedGender: widget.selectedGender,
                                    showGenderOnProfile: widget.showGenderOnProfile,
                                    showMode: widget.showMode,
                                    gendermode:widget.gendermode,
                                    selectionOptionIds:selectedOptionIds
              
                        )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select 2 options"))
                        );
                      }
                    },
                    // onPressed: () => {
                    //    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> HeightSelectionScreen()))
                    // },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}