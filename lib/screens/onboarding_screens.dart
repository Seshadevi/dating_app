import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/introMail.dart';
import 'mode_screen.dart';
import '../screens/meet_selection.dart';
import '../screens/partners_selections.dart';
import '../screens/height_selection_screen.dart';
import '../screens/choose_foodies.dart';
import '../screens/valueSelection.dart';
import '../screens/lifeStryle_habits.dart';
import '../screens/familyPlaneScreen.dart';
import '../screens/importantLife.dart';
import '../screens/causes_Community.dart';
import 'datePromtSelection.dart';
import '../screens/openingMoveScreen.dart';
import '../screens/addHeadlineScreen.dart';

class OnboardingScreen extends ConsumerStatefulWidget{
  final double latitude;
  final double longitude;
  const OnboardingScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
 

  final PageController _controller = PageController();
  String userName = '';
  String dateOfBirth = ''; // in format MM/DD/YYYY

  String _month = '';
  String _day = '';
  String _year = '';
  String userEmail = '';
  String selectedGenderMode = '';




  int currentIndex = 0;
  String selectedGender = "";
  String selectedPurpose = "";
  bool showGenderOnProfile = true;
  
 
  
var selectedMode;

  List<Color> get primaryGradient =>
      [const Color(0xFF869E23), const Color(0xFF000000)];

  List<Widget> get pages => [
        _buildIntroPage(context),
        _buildGenderSelectionPage(context),
        _buildGenderDisplayPage(),
        _buildMailPage(),
        _buildDateCategory(),
        _buildMeetSelection(),
        // _buildPartnersSelections(),
        // _buildHeightSelection(),
        // _buildChooseFoodies(),
        // _buildChooseValues(),
        // _buildLifestyleHabits(),
        // _buildFamilyScreen(),
        // _buildImportantLife(),
        // _buildcause(),
        // _buildDatePromt(),
        // _buildPhotoUploadPage(),
        // _buildOpeningMove(),
        // _buildPurposeSelectionPage(),
        // _buildFinalInfoPage(),
      ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // ✅ Navigate to the next screen when the last page is reached
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const AddHeadlineScreen()), // Replace with your target screen
      );
    }
  }

  

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return "Oh Hey! Let's Start\nWith An Intro";
      case 1:
        return "Greate Name";
      case 2:
        return "Want To Show Your Gender On Your Profile";
      case 3:
        return "Can We Get Email?";
      case 4:
        return "What Brings You Here?";
      case 5:
        return "Who Would Like TO Meet?";
      // case 6:
      //   return "And What Are You\nHoping To Find?";
      // case 7:
      //   return "Now lets Talk About You";
      // case 8:
      //   return "Choose Five Things You Are Really Into";
      // case 9:
      //   return "Tell Us What You Value In A Person";
      // case 10:
      //   return "Lets Talk About Your Hobits And LifeStyle ";
      // case 11:
      //   return "Do You Have Kids Or\nFamily Plans?";
      // case 12:
      //   return "Whats's Important In Your Life?";
      // case 13:
      //   return "How About Causes And Communities";
      // case 14:
      //   return "What’s It Like To Date You?";
      // case 15:
      //   return "TIme To Put A FAce To The Name";
      // case 16:
      //   return "What will You Opening Move Be";
      default:
        return "";
    }
  }
  @override
  void initState() {
    super.initState();
    print(
        "Latitude::::::: ${widget.latitude}, Longitude::::::: ${widget.longitude}");
    print('username..........$userName');
    print('date of birth...........$dateOfBirth');
    print('gender selected.........$selectedGender');
    print('showgender..............$showGenderOnProfile');
    print('userEmail...........$userEmail');
    print('selectedGenderMode..........$selectedGenderMode');
    print('');
    

  }

  @override
  Widget build(BuildContext context) {
    // print('logitude..........$longitude');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                // Background track
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Gradient progress fill
                FractionallySizedBox(
                  widthFactor: (currentIndex + 1) / pages.length,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: primaryGradient, // Define this as a List<Color>
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Back and Skip buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(height: 40,),
                // Back Button (disabled on first screen)
                if (currentIndex >= 1 && currentIndex <= 14)
                  GestureDetector(
                      onTap: () {
                        if (currentIndex > 0) {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        // arrow_forward_ios
                        color: Colors.black,
                        size: 30,
                      ))
                else
                  const SizedBox(width: 50), // to align Skip properly

                // Skip Button (only if not on last screen)
                if (currentIndex >= 8 && currentIndex <= 14)
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(pages.length - 1);
                      setState(() {
                        currentIndex = pages.length - 1;
                      });
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 50),
              ],
            ),
          ),
          // const SizedBox(height: 20),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
              child: Text(
                _getPageTitle(currentIndex),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Inter Tight',
                  fontSize: 30.0,
                  letterSpacing: 0.38,
                  fontWeight: FontWeight.bold,
                  height: 0.00,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentIndex = index),
              children: pages,
            ),
          ),
          // GestureDetector(
          //   onTap: nextPage,
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 10),
          //     child: CircleAvatar(
          //       radius: 24,
          //       backgroundColor: Colors.green.shade700,
          //       child: Icon(Icons.arrow_forward_ios, color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

 Widget _buildIntroPage(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Stack(
    children: [
      // 🎨 Your background decorations
      Positioned(
        left: -50,
        top: 300,
        child: Image.asset(
          'assets/CornerEllipse.png',
          width: screenWidth * 0.4,
        ),
      ),
      Positioned(
        left: screenWidth * 0.075,
        top: screenWidth * 0.96,
        child: Image.asset(
          'assets/Ellipse_439.png',
          width: screenWidth * 0.25,
        ),
      ),
      Positioned(
        top: screenWidth * 1.05,
        right: screenWidth * 0.05,
        child: Image.asset(
          'assets/balloons.png',
          width: screenWidth * 0.4,
        ),
      ),

      // 🧾 Foreground content with form
      Positioned.fill(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _styledInput(
                label: "Your First Name",
                hint: "Enter your name",
                onChanged: (value) {
                  setState(() => userName = value);
                },
              ),
              const SizedBox(height: 40),
              const Text("Your Birthday", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _birthdayInput("Month", (value) {
                    setState(() {
                      _month = value;
                      dateOfBirth = '$_month/$_day/$_year';
                    });
                  })),
                  const SizedBox(width: 10),
                  Expanded(child: _birthdayInput("Day", (value) {
                    setState(() {
                      _day = value;
                      dateOfBirth = '$_month/$_day/$_year';
                    });
                  })),
                  const SizedBox(width: 10),
                  Expanded(child: _birthdayInput("Year", (value) {
                    setState(() {
                      _year = value;
                      dateOfBirth = '$_month/$_day/$_year';
                    });
                  })),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "It’s Never Too Early To Count Down",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 120), // give some space so button won't overlap
            ],
          ),
        ),
      ),

      // ✅ NEXT BUTTON HERE
      Positioned(
        bottom: 24,
        right: 24,
        child: Align(
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
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  if (userName.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty && _year.isNotEmpty) {
                    nextPage(); // ⬅ from parent class
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields")),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildGenderDisplayPage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Decorative images behind the content
        Positioned(
          left: 0,
          bottom: 0,
          child: Image.asset(
            'assets/mail_frame.png',
            fit: BoxFit.contain,
          ),
        ),

        // Main content on top
        _pageWrapper(
          children: [
            const Text(
              "It’s Totally Up To You Whether\nYou Feel Comfortable Sharing\nThis.",
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            const Text(
              "Shown As:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(selectedGender.isEmpty ? "Man" : selectedGender),
              backgroundColor: primaryGradient.first,
            ),
            Row(
              children: [
                const Text(
                  "Show On Profile",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Switch(
                  value: showGenderOnProfile,
                  onChanged: (val) => setState(() => showGenderOnProfile = val),
                  activeColor: primaryGradient.first,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 120,),
        Positioned(
        bottom: 24,
        right: 24,
        child: Align(
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
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  if (userName.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty && _year.isNotEmpty) {
                    nextPage(); // ⬅ from parent class
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields")),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      ],
    );
  }

 Widget _buildMailPage() {
  return IntroMail(
    latitude: widget.latitude,
    longitude: widget.longitude,
    userName: userName,
    dateOfBirth: dateOfBirth,
    selectedGender: selectedGender,
    showGenderOnProfile: showGenderOnProfile,
  );
}


 Widget _buildDateCategory() {
  return IntroDatecategory(
    email: userEmail,                    // From a text field
    latitude: widget.latitude,                      // From constructor param
    longitude: widget.longitude,                    // From constructor param
    userName: userName,                      // From constructor param
    dateOfBirth: dateOfBirth,                // From constructor param
    selectedGender: selectedGender,          // From constructor param
    showGenderOnProfile: showGenderOnProfile // From constructor param
  );
}



  Widget _buildMeetSelection() {
    return IntroMeetselection(
                                    email:userEmail ,
                                    latitude: widget.latitude,
                                    longitude: widget.longitude,
                                    userName: userName,
                                    dateOfBirth: dateOfBirth,
                                    selectedGender: selectedGender,
                                    showGenderOnProfile:showGenderOnProfile,
                                    showMode:selectedMode
    ); // You already built this as a full screen widget
  }

  // Widget _buildPartnersSelections() {
  //   return const InrtoPartneroption(); // You already built this as a full screen widget
  // }

  // Widget _buildHeightSelection() {
  //   return const HeightSelectionScreen(); // You already built this as a full screen widget
  // }

  // Widget _buildChooseFoodies() {
  //   return InterestsScreen(); // You already built this as a full screen widget
  // }

  // Widget _buildChooseValues() {
  //   return ValuesSelectionScreen(); // You already built this as a full screen widget==============
  // }

  // Widget _buildLifestyleHabits() {
  //   return LifestyleHabitsScreen(); // You already built this as a full screen widget============
  // }

  // Widget _buildFamilyScreen() {
  //   return FamilyPlanScreen(); // You already built this as a full screen widget
  // }

  // Widget _buildImportantLife() {
  //   return ReligionSelectorWidget(); // You already built this as a full screen widget==============
  // }

  // Widget _buildcause() {
  //   return CausesScreen(); // You already built this as a full screen widget==================
  // }

  // Widget _buildDatePromt() {
  //   return DatePromptScreen(); // You already built this as a full screen widget
  // }

  // Widget _buildOpeningMove() {
  //   return OpeningMoveScreen(); // You already built this as a full screen widget
  // }

  Widget _buildGenderSelectionPage(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    return _pageWrapper(
      children: [
        const SizedBox(height: 10),
        const Text("Pick The Gender That Best Describes You."),
        const SizedBox(height: 20),
        _radioOption("Woman", isPurpose: false),
        _radioOption("Man", isPurpose: false),
        _radioOption("Nonbinary", isPurpose: false),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Center(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade500,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  children: [
                    TextSpan(text: "You Can Always Update This Later. "),
                    TextSpan(
                      text: "A Note About Gender On HeartSync.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            SizedBox(height: 120,),
             // ✅ NEXT BUTTON HERE

      // Stack(
        // children: [
          Positioned(
          bottom: 24,
          right: 24,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: screenWidth * 0.125,
                height: screenWidth * 0.125,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 99, 118, 3), Color(0xff000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    if (userName.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty && _year.isNotEmpty) {
                      nextPage(); // ⬅ from parent class
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in all fields")),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        // ]
      // ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploadPage() {
    return _pageWrapper(
      children: [
        const Text(
            "Do You Want Add Atleast 4 Photos, Weather Its You With Your Pet,Eating Your Fav Food or In A Place You Most Love"),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(6, (index) {
            return Container(
              width: 90,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add),
            );
          }),
        ),
      ],
    );
  }

  Widget _radioOption(String value, {required bool isPurpose}) {
    bool isSelected =
        isPurpose ? selectedPurpose == value : selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isPurpose) {
            selectedPurpose = value;
          } else {
            selectedGender = value;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryGradient.first : Color(0xffE9F1C4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(value,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black))),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageWrapper({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _styledInput({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged, // ⬅️ capture name
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            filled: true,
            fillColor: const Color(0xffE9F1C4),
          ),
        ),
      ],
    );
  }

  Widget _birthdayInput(String hint, ValueChanged<String> onChanged) {
    return Expanded(
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff92AB26)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true,
          fillColor: const Color(0xffE9F1C4),
        ),
      ),
    );
  }
}
