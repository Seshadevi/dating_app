import 'package:dating/provider/signupprocessProviders/choosr_foodies_provider.dart';
import 'package:dating/screens/valueSelection.dart';
import 'package:dating/screens/height_selection_screen.dart';
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
  final dynamic showMode;
  final String? gendermode;
  final dynamic selectedHeight;
  final dynamic selectionOptionIds;

  const InterestsScreen({
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
    required this.selectedHeight,
    this.selectionOptionIds,
  });

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  List<String> selectedInterests = [];
  List<int> selectedInterestIds = [];

  void toggleInterest(String interest, int id) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
        selectedInterestIds.remove(id);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
          selectedInterestIds.add(id);
        }
      }
    });
  }

  List<Offset> generateDynamicPositions(int count) {
    List<Offset> positions = [];
    double startX = 20;
    double startY = 20;
    double gapX = 110;
    double gapY = 110;

    for (int i = 0; i < count; i++) {
      double x = startX + (i % 3) * gapX + (i.isEven ? 10 : -10);
      double y = startY + (i ~/ 3) * gapY + ((i % 3 == 0) ? 20 : 0);
      positions.add(Offset(x, y));
    }
    return positions;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(interestsProvider.notifier).getInterests());
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final interestsModel = ref.watch(interestsProvider);
    final interestsList = interestsModel.data ?? [];
    final positions = generateDynamicPositions(interestsList.length);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: 10 / 18,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 147, 179, 3)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HeightSelectionScreen(
                                email: widget.email,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                userName: widget.userName,
                                dateOfBirth: widget.dateOfBirth,
                                selectedGender: widget.selectedGender,
                                showGenderOnProfile: widget.showGenderOnProfile,
                                selectionOptionIds: widget.selectionOptionIds,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
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
                                selectionOptionIds: widget.selectionOptionIds,
                                // selectedIntersts: selectedInterests,
                                selectedInterestIds: selectedInterestIds,
                              ),
                            ),
                          ),
                          child: const Text('Skip', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Choose Five Things\nYou Are Really Into",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Proud foodie or big on bouldering?\nAdd interests to your profile to help you match with people who love them too.',
                      style: TextStyle(color: Colors.black87, fontSize: screen.width * 0.04),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF0D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(hintText: 'What are you into?', border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Selected interests
                    if (selectedInterests.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedInterests.map((interest) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Chip(
                                  label: Text(interest),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    final index = selectedInterests.indexOf(interest);
                                    if (index != -1) {
                                      toggleInterest(interest, selectedInterestIds[index]);
                                    }
                                  },
                                  backgroundColor: Colors.lightGreen.shade100,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 20),
                    if (interestsList.isEmpty)
                      const Center(child: Text("No interests found."))
                    else
                      SizedBox(
                        height: screen.height * 0.7,
                        child: Stack(
                          children: List.generate(interestsList.length, (index) {
                            final item = interestsList[index];
                            final isSelected = selectedInterests.contains(item.interests);
                            final pos = positions[index];

                            return Positioned(
                              top: pos.dy,
                              left: pos.dx,
                              child: GestureDetector(
                                onTap: () => toggleInterest(item.interests ?? '', item.id ?? 0),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected
                                        ? const LinearGradient(colors: [Color(0xFF869E23), Color(0xFF000000)])
                                        : const LinearGradient(colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)]),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                  ),
                                  child: Text(
                                    item.interests ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${selectedInterests.length}/5 Selected', style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(width: 10),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: screen.width * 0.125,
                            height: screen.width * 0.125,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xffB2D12E), Color(0xff000000)]),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                              onPressed: () {
                                if (selectedInterests.isNotEmpty) {
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
                                        selectionOptionIds: widget.selectionOptionIds,
                                        // selectedIntersts: selectedInterests,
                                        selectedInterestIds: selectedInterestIds,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select at least one interest")),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
