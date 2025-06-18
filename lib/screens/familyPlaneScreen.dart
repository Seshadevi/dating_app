import 'package:dating/provider/signupprocessProviders/kidsProvider.dart';
import 'package:dating/screens/importantLife.dart';
import 'package:dating/screens/lifeStryle_habits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyPlanScreen extends ConsumerStatefulWidget {
  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final showMode;
  final String? gendermode;
  final dynamic selectionOptionIds;
  final dynamic selectedHeight;
  final List<int> selectedInterestIds;
  final List<int> selectedqualitiesIDs;
  final List<int> selectedhabbits;

  const FamilyPlanScreen({
    super.key,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.userName,
    required this.dateOfBirth,
    required this.selectedGender,
    required this.showGenderOnProfile,
    this.showMode,
    this.gendermode,
    this.selectionOptionIds,
    this.selectedHeight,
    required this.selectedInterestIds,
    required this.selectedqualitiesIDs,
    required this.selectedhabbits,
  });

  @override
  ConsumerState<FamilyPlanScreen> createState() => _FamilyPlanScreenState();
}

class _FamilyPlanScreenState extends ConsumerState<FamilyPlanScreen> {
  Set<int> selectedKidsIds = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kidsProvider.notifier).getKids());
  }

  void toggleSelect(int id) {
    setState(() {
      if (selectedKidsIds.contains(id)) {
        selectedKidsIds.remove(id);
      } else {
        selectedKidsIds.add(id);
      }
    });
  }

  Widget optionButton(String text, int id, double size, double fontSize) {
    bool isSelected = selectedKidsIds.contains(id);
    return GestureDetector(
      onTap: () => toggleSelect(id),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF869E23), Color(0xFF000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                ),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.07),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final bubbleSize = screen.width * 0.3;
    final bubbleFont = screen.width * 0.035;
    final kidsState = ref.watch(kidsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05),
                child: ListView(
                  children: [
                    LinearProgressIndicator(
                      value: 13 / 18,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 147, 179, 3)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LifestyleHabitsScreen(
                                email: widget.email,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                userName: widget.userName,
                                dateOfBirth: widget.dateOfBirth,
                                selectedGender: widget.selectedGender,
                                showGenderOnProfile: widget.showGenderOnProfile,
                                showMode: widget.showMode,
                                gendermode: widget.gendermode,
                                selectionOptionIds: widget.selectionOptionIds,
                                selectedHeight: widget.selectedHeight,
                                selectedInterestIds: widget.selectedInterestIds,
                                selectedqualitiesIDs:
                                    widget.selectedqualitiesIDs,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReligionSelectorWidget(
                                email: widget.email,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                userName: widget.userName,
                                dateOfBirth: widget.dateOfBirth,
                                selectedGender: widget.selectedGender,
                                showGenderOnProfile: widget.showGenderOnProfile,
                                showMode: widget.showMode,
                                gendermode: widget.gendermode,
                                selectionOptionIds: widget.selectionOptionIds,
                                selectedHeight: widget.selectedHeight,
                                selectedInterestIds: widget.selectedInterestIds,
                                selectedqualitiesIDs:
                                widget.selectedqualitiesIDs,
                                selectedhabbits: widget.selectedhabbits,
                                selectedKidsIds: selectedKidsIds.toList(),
                              ),
                            ),
                          ),
                          child: const Text('Skip',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Do You Have Kids Or\nFamily Plans?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    Text(
                      "Let’s get deeper. Feel free to skip if you'd prefer not to say.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: screen.width * 0.035,
                      ),
                    ),
                    Text(
                      "Have Kids",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.045,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        optionButton("Have Kids +", -1, bubbleSize, bubbleFont),
                        optionButton(
                            "Don’t Have\nKids ++", -2, bubbleSize, bubbleFont),
                      ],
                    ),
                    SizedBox(height: screen.height * 0.03),
                    Text(
                      "Kids",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.045,
                      ),
                    ),
                    if (kidsState.data == null || kidsState.data!.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: screen.width * 0.02,
                        runSpacing: screen.height * 0.015,
                        children: kidsState.data!.map((kid) {
                          return optionButton(kid.kids ?? '', kid.id ?? 0,
                              bubbleSize, bubbleFont);
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screen.width * 0.05,
                vertical: screen.height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedKidsIds.length} Selected",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screen.width * 0.04,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: screen.width * 0.125,
                      height: screen.width * 0.125,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xff000000)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        onPressed: () {
                          if (selectedKidsIds.isNotEmpty) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReligionSelectorWidget(
                                  email: widget.email,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  userName: widget.userName,
                                  dateOfBirth: widget.dateOfBirth,
                                  selectedGender: widget.selectedGender,
                                  showGenderOnProfile:
                                      widget.showGenderOnProfile,
                                  showMode: widget.showMode,
                                  gendermode: widget.gendermode,
                                  selectionOptionIds: widget.selectionOptionIds,
                                  selectedHeight: widget.selectedHeight,
                                  selectedInterestIds:
                                      widget.selectedInterestIds,
                                  selectedqualitiesIDs:
                                      widget.selectedqualitiesIDs,
                                  selectedhabbits: widget.selectedhabbits,
                                  selectedKidsIds: selectedKidsIds.toList(),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please select at least one option")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}