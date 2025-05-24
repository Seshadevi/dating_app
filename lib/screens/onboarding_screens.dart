import 'package:flutter/material.dart';
import '../screens/introMail.dart';
import '../screens/datecategory.dart';
import '../screens/meet_selection.dart';
import '../screens/partners_selections.dart';
import '../screens/height_selection_screen.dart';
import '../screens/choose_foodies.dart';
import '../screens/valueSelection.dart';
import '../screens/lifeStryle_habits.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  String selectedGender = "";
  String selectedPurpose = "";
  bool showGenderOnProfile = true;

  List<Color> get primaryGradient =>
      [const Color(0xFF869E23), const Color(0xFF000000)];

  List<Widget> get pages => [
        _buildIntroPage(context),
        _buildGenderSelectionPage(),
        _buildGenderDisplayPage(),
        _buildMailPage(),
        _buildDateCategory(),
        _buildMeetSelection(),
        _buildPartnersSelections(),
         _buildHeightSelection(),
          _buildChooseFoodies(), 
          _buildChooseValues(),
          _buildLifestyleHabits(),
        _buildPhotoUploadPage(),
        _buildPurposeSelectionPage(),
        _buildFinalInfoPage(),
      ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
      case 6:
        return "And What Are You\nHoping To Find?";
        case 7:
        return "Choose Five Things You Are Really Into";
        case 8:
        return "Tell Us What You Value In A Person";
        case 9:
        return "Tell Us What You Value In A Person";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
              child: Text(
                _getPageTitle(currentIndex),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Inter Tight',
                  fontSize: 25.0,
                  letterSpacing: 0.38,
                  fontWeight: FontWeight.bold,
                  height: 1.32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentIndex = index),
              children: pages,
            ),
          ),
          GestureDetector(
            onTap: nextPage,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Icon(Icons.arrow_forward_ios,
                  size: 40, color: primaryGradient.first),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // === Positioned Background Images ===
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

        // === Main content on top of the images ===
        _pageWrapper(
          children: [
            const SizedBox(height: 40),
            _styledInput(label: "Your First Name", hint: "Enter your name"),
            const SizedBox(height: 40),
            const Text(
              "Your Birthday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _birthdayInput("Month"),
                const SizedBox(width: 10),
                _birthdayInput("Day"),
                const SizedBox(width: 10),
                _birthdayInput("Year"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "It’s Never Too Early To Count Down",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
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
      ],
    );
  }

  Widget _buildMailPage() {
    return const IntroMail(); // You already built this as a full screen widget
  }

  Widget _buildDateCategory() {
    return const IntroDatecategory(); // You already built this as a full screen widget
  }

  Widget _buildMeetSelection() {
    return const IntroMeetselection(); // You already built this as a full screen widget
  }
   Widget _buildPartnersSelections() {
    return const InrtoPartneroption(); // You already built this as a full screen widget
  }
  Widget _buildHeightSelection() {
    return const HeightSelectionScreen(); // You already built this as a full screen widget
  }
   Widget _buildChooseFoodies() {
    return  InterestsScreen(); // You already built this as a full screen widget
  }
   Widget _buildChooseValues() {
    return  ValuesSelectionScreen(); // You already built this as a full screen widget
  }
   Widget _buildLifestyleHabits() {
    return  InterestSelectionScreen(); // You already built this as a full screen widget
  }


  Widget _buildGenderSelectionPage() {
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
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoUploadPage() {
    return _pageWrapper(
      children: [
        const Text("Add At Least 4 Photos"),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(6, (index) {
            return Container(
              width: 80,
              height: 100,
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

  Widget _buildPurposeSelectionPage() {
    return _pageWrapper(
      children: [
        const Text("Choose A Mode To Find Your People"),
        const SizedBox(height: 20),
        _radioOption("Date", isPurpose: true),
        _radioOption("BFF", isPurpose: true),
        _radioOption("Bizz", isPurpose: true),
        const SizedBox(height: 20),
        const Text("You'll Only Be Shown To People In The Same Mode As You."),
      ],
    );
  }

  Widget _buildFinalInfoPage() {
    return _pageWrapper(
      children: [
        const Text("BFF Will Help You Find New Friendships"),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGradient.first,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {},
            child: const Text("Got It",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        )
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

  Widget _styledInput({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            filled: true,
            fillColor: Color(0xffE9F1C4),
          ),
        )
      ],
    );
  }

  Widget _birthdayInput(String hint) {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff92AB26)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          filled: true, // Enables the background color
          fillColor: Color(0xffE9F1C4),
          // Set your desired background color here
        ),
      ),
    );
  }
}
