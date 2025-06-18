import 'package:dating/provider/signupprocessProviders/genderProvider.dart';
import 'package:dating/screens/mode_screen.dart';
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
  List<String> selectedGenderIds = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(genderProvider.notifier).getGender());
  }

  @override
  Widget build(BuildContext context) {
    final genderState = ref.watch(genderProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          _buildProgressBar(),
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "you can choose more than one answer and change it any time.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                _buildToggleOption(genderState),
                const SizedBox(height: 10),
                if (genderState.data != null)
                  ...genderState.data!.map((gender) =>
                    _buildGenderOption(gender)
                  ),
                const SizedBox(height: 10),
                _buildVisibilityNote(),
              ],
            ),
          ),
          _buildNextButton(screenWidth, genderState),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LinearProgressIndicator(
        value: 7 / 18,
        backgroundColor: Colors.grey[300],
        valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 147, 179, 3)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => IntroDatecategory(
                    email: widget.email,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    userName: widget.userName,
                    dateOfBirth: widget.dateOfBirth,
                    selectedGender: widget.selectedGender,
                    showGenderOnProfile: widget.showGenderOnProfile,
                  ),
                ),
              );
            },
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
    );
  }

  Widget _buildToggleOption(genderState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Switch(
          value: isOpenToEveryone,
          onChanged: (value) {
            setState(() {
              isOpenToEveryone = value;
              if (value) {
                selectedGenderIds.clear();
                selectedMode = null;
                // Add all gender IDs from API
                if (genderState.data != null) {
                  selectedGenderIds = genderState.data!.map((e) => e.id.toString()).toList();
                }
              } else {
                selectedGenderIds.clear(); // reset on turning off toggle
              }
            });
          },
          activeTrackColor: const Color(0xffB2D12E),
          activeColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD3D3D3),
          inactiveThumbColor: Colors.white,
        ),
        const Text(
          "I'm open to dating everyone",
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

  Widget _buildGenderOption(Data gender) {
    final isSelected = selectedGenderIds.contains(gender.id.toString());

    return InkWell(
      onTap: isOpenToEveryone
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  selectedGenderIds.remove(gender.id.toString());
                } else {
                  selectedGenderIds.add(gender.id.toString());
                }
              });
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

  Widget _buildVisibilityNote() {
    return Row(
      children: [
        Icon(Icons.remove_red_eye_outlined, color: Colors.grey[600], size: 24),
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
    );
  }

  Widget _buildNextButton(double screenWidth, genderState) {
    return Align(
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
                if (selectedGenderIds.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InrtoPartneroption(
                        email: widget.email,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        userName: widget.userName,
                        dateOfBirth: widget.dateOfBirth,
                        selectedGender: widget.selectedGender,
                        showGenderOnProfile: widget.showGenderOnProfile,
                        showMode: widget.showMode,
                        gendermode: selectedGenderIds,
                        // selectedGenderIds: selectedGenderIds, // send list here
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select at least one gender preference")),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
