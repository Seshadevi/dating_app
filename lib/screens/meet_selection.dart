import 'package:dating/provider/signupprocessProviders/genderProvider.dart';
import 'package:dating/screens/partners_selections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/signupprocessmodels/genderModel.dart';
// import '../../provider/signupproviders/gender_provider.dart'; // adjust your import if needed

class IntroMeetselection extends ConsumerStatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final  showMode;

  const IntroMeetselection({
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    required this.showMode,
  });

  @override
  ConsumerState<IntroMeetselection> createState() => _IntroMeetselectionState();
}

class _IntroMeetselectionState extends ConsumerState<IntroMeetselection> {
  String? selectedMode;
  bool isOpenToEveryone = false;

  @override
  void initState() {
    super.initState();
    // Fetch genders when widget loads
    Future.microtask(() => ref.read(genderProvider.notifier).getGender());
  }

  @override
  Widget build(BuildContext context) {
    final genderState = ref.watch(genderProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: 6 / 16,
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
                      "Who Would Like TO Meet?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "you can choose more than one answer and change it any time.",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
      
                _buildToggleOption(),
      
                if (genderState.data != null)
                  ...genderState.data!.map((gender) =>
                    _buildGenderOption(gender)
                  ),
      
                const SizedBox(height: 10),
      
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
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
                // const SizedBox(height: 10),
              ],
            ),
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
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {
                    if (selectedMode != null || isOpenToEveryone) {
                      print("✅ Proceeding with:");
                      print("Email: ${widget.email}");
                      print("Lat: ${widget.latitude}, Long: ${widget.longitude}");
                      print("Username: ${widget.userName}");
                      print("DOB: ${widget.dateOfBirth}");
                      print("Gender: ${widget.selectedGender}");
                      print("Show Gender: ${widget.showGenderOnProfile}");
                      print("Selected Mode: ${widget.showMode.value} (ID: ${widget.showMode.id})");
                      print("Selected Looking For: ${isOpenToEveryone ? "Everyone" : selectedMode}");
                      print("email............${widget.email}");
      
                      // Navigator.push(...) your next screen here
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> InrtoPartneroption(
                         email: widget.email,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  userName: widget.userName,
                                  dateOfBirth: widget.dateOfBirth,
                                  selectedGender: widget.selectedGender,
                                  showGenderOnProfile: widget.showGenderOnProfile,
                                  showMode: widget.showMode,
                                  gendermode:selectedMode

                      )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a gender preference"))
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gender Option Builder
  Widget _buildGenderOption(Data gender) {
    final isSelected = selectedMode == gender.value;

    return InkWell(
      onTap: () {
        if (!isOpenToEveryone) {
          setState(() {
            selectedMode = gender.value;
          });
        }
      },
      child: Opacity(
        opacity: isOpenToEveryone ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff92AB26) : const Color(0xffE9F1C4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              width: 2,
              color: isSelected ? const Color(0xffE9F1C4) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                gender.value ?? '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  color: isSelected ? Colors.white : const Color(0xFF5A7651),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : const Color(0xFF5A7651),
                    width: 2,
                  ),
                  color: isSelected ? const Color(0xFF5A7651) : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
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
    );
  }

  /// Toggle Switch
  Widget _buildToggleOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Switch(
          value: isOpenToEveryone,
          onChanged: (value) {
            setState(() {
              isOpenToEveryone = value;
              if (value) {
                selectedMode = null;
              }
            });
          },
          activeTrackColor: const Color(0xffB2D12E),
          activeColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD3D3D3),
          inactiveThumbColor: Colors.white,
        ),
        const Text(
          "i'm open to dating everyone",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 60, 60, 60),
          ),
        ),
      ],
    );
  }
}
