import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'gender_display_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? entryemail;
  String? mobile;
  double? latitude;
  double? longitude;
  String? dateofbirth;
  String? userName;
  String selectedGender = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      // Prevent overwriting selected products
      setState(() {
        entryemail = args['email'] ?? '';
        mobile = args['mobile'] ?? '';
        latitude = args['latitude'] ?? 0.0;
        longitude = args['longitude'] ?? 0.0;
        dateofbirth = args['dateofbirth'] ?? '';
        userName = args['userName'] ?? '';
        if (args['selectgender'] != null && args['selectgender'] is String) {
          selectedGender = args['selectgender'];
        }
        print('select gender.........$selectedGender');
      });
    }
  }

  Widget _buildGenderOption(String label) {
    final bool isSelected = selectedGender == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [DatingColors.white,DatingColors.lightpinks],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? DatingColors.black : DatingColors.lightgrey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? DatingColors.white : DatingColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? DatingColors.brown : DatingColors.lightgrey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:DatingColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: 2 / 18,
                    backgroundColor:DatingColors.surfaceGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      DatingColors.everqpidColor,
                    ),
                  ),
                  // const SizedBox(height: 24),
                  Row(children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/intropage',
                          arguments: {
                            'latitude': latitude,
                            'longitude': longitude,
                            'dateofbirth': dateofbirth,
                            'userName': userName,
                            'email': entryemail,
                            'mobile': mobile
                          },
                        );
                      },
                    ),
                    //  Text(
                    //   "$userName",
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //     fontFamily: 'Poppins',
                    //   ),
                    // ),
                  ]),
                  const SizedBox(height: 12),
                  // const Text(
                  //   "We Love That You're Here. Pick The Gen\n-der That Best Describes You, Then Add \n More About It If You Like.",
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     fontFamily: 'Inter',
                  //     height: 1.5,
                  //   ),
                  // ),
                  const SizedBox(height: 28),
                  const Text(
                    "Please Select Your Gender?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Gender options
                  _buildGenderOption("She/Her"),
                  _buildGenderOption("He/Him"),
                  // she/her,he/him
                  // _buildGenderOption("Nonbinary"),

                  const SizedBox(height: 12),

                  // Info section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 18, color: DatingColors.lightgrey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color: DatingColors.lightgrey,
                            ),
                            children: [
                              const TextSpan(
                                  text: "You Can Always Update This Later. "),
                              TextSpan(
                                text: "A Note About Gender On Bumble.",
                                style: TextStyle(
                                  color: DatingColors.darkGrey,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Next FAB button
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
                        colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: DatingColors.white),
                      onPressed: () {
                        if (selectedGender.isNotEmpty) {
                          // Navigator.pushNamed(
                          //   context,
                          //   '/profileshowscreen',
                          //   arguments: {
                          //     'latitude': latitude,
                          //     'longitude': longitude,
                          //     'dateofbirth': dateofbirth,
                          //     'userName': userName,
                          //     'selectgender': selectedGender,
                          //     'email': entryemail,
                          //     'mobile': mobile
                          //   },
                          // );
                           Navigator.pushNamed(
                            context,
                            '/emailscreen',
                            arguments: {
                              'latitude': latitude,
                              'longitude': longitude,
                              'dateofbirth':dateofbirth,
                              'userName':userName,
                              'selectgender':selectedGender,
                              // "showonprofile":showGenderOnProfile,
                              'email':entryemail,
                              'mobile':mobile
                            },);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a gender")),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
