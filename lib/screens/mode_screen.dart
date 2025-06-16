import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/signupprocessProviders/modeProvider.dart';
import 'package:dating/screens/meet_selection.dart';
import '../model/signupprocessmodels/modeModel.dart';

class IntroDatecategory extends ConsumerStatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;

  const IntroDatecategory({
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
  });

  @override
  ConsumerState<IntroDatecategory> createState() => _IntroDatecategoryState();
}

class _IntroDatecategoryState extends ConsumerState<IntroDatecategory> {
  Data? selectedMode;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(modesProvider.notifier).getModes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final modeModel = ref.watch(modesProvider);
    final modes = modeModel.data ?? [];
    final isLoading = modeModel.data == null || modeModel.data!.isEmpty;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: 5 / 16,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffB2D12E)),
                ),
              ),
              const SizedBox(height: 20),
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
                      "What Brings You Here?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Romance and Butterflies or a Beautiful Friendship?\nChoose a mode to find your people.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Mode list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: modes.length,
                        itemBuilder: (context, index) {
                          final mode = modes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildModeOption(mode),
                          );
                        },
                      ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You’ll only be shown to people in the same mode as you.",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.4,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                          if (selectedMode != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IntroMeetselection(
                                  email: widget.email,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  userName: widget.userName,
                                  dateOfBirth: widget.dateOfBirth,
                                  selectedGender: widget.selectedGender,
                                  showGenderOnProfile: widget.showGenderOnProfile,
                                  showMode: selectedMode!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select a mode")),
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
        ],
      ),
    );
  }

  Widget _buildModeOption(Data mode) {
    final isSelected = selectedMode?.id == mode.id;
    final textColor = isSelected ? Colors.white : const Color.fromARGB(255, 90, 118, 81);

    return InkWell(
      onTap: () => setState(() => selectedMode = mode),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff92AB26) : const Color(0xffE9F1C4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: isSelected ? const Color(0xffE9F1C4) : Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mode.value ?? '',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
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
                          : const Color.fromARGB(255, 90, 118, 81),
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color.fromARGB(255, 90, 118, 81)
                        : Colors.transparent,
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
            const SizedBox(height: 8),
            Text(
              getModeDescription(mode.value ?? ''),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getModeDescription(String mode) {
    switch (mode.toLowerCase()) {
      case 'date':
        return "Find a relationship, something casual, or anything in-between";
      case 'bff':
        return "Make new friends and find your community";
      case 'bizz':
        return "Network professionally and make career moves";
      default:
        return "Explore this mode";
    }
  }
}
