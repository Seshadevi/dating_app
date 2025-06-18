import 'dart:io';

import 'package:dating/provider/signupprocessProviders/defaultmessages.dart';
import 'package:dating/screens/addHeadlineScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpeningMoveScreen extends ConsumerStatefulWidget {

  final String email;
  final double latitude;
  final double longitude;
  final String userName;
  final String dateOfBirth;
  final String selectedGender;
  final bool showGenderOnProfile;
  final dynamic showMode;
  final String? gendermode;
  final List<int> selectionOptionIds;
  final dynamic selectedHeight;
  final List<int> selectedInterestIds;
  final List<int> selectedqualitiesIDs;
  final List<int> selectedhabbits;
  final List<int> selectedkids;
  final List<int> selectedreligions;
  final List<int> selectedcauses;
  final List<String> seletedprompts;
  final List<File?> choosedimages;

  const OpeningMoveScreen({
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
    required this.selectionOptionIds,
    this.selectedHeight,
    required this.selectedInterestIds,
    required this.selectedqualitiesIDs,
    required this.selectedhabbits,
    required this.selectedkids,
    required this.selectedreligions,
    required this.selectedcauses,
    required this.seletedprompts,
    required this.choosedimages
    }) ;

  @override
  ConsumerState<OpeningMoveScreen> createState() => _OpeningMoveScreenState();
}

class _OpeningMoveScreenState extends ConsumerState<OpeningMoveScreen> {
  final List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    // Fetch messages when screen loads
    Future.microtask(() => ref.read(defaultmessagesProvider.notifier).getdefaultmessages());
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final defaultMessages = ref.watch(defaultmessagesProvider);
    final prompts = defaultMessages.data?.map((e) => e.message ?? '').toList() ?? [];

    return Scaffold(
      
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            LinearProgressIndicator(
                value: 18/ 18,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xffB2D12E)),
              ),
              // const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context); // You can customize this
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Skip navigation
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              const Text(
                "What will opening Move Be?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 10),
            const Text(
              "Choose A First Message For All\nYour New Matches To Reply To.\nEasy!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            // const SizedBox(height: 20),
            if (prompts.isEmpty)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: prompts.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndexes.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndexes.remove(index);
                          } else if (selectedIndexes.length < 3) {
                            selectedIndexes.add(index);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8E7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(0xffB2D12E): Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                prompts[index],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? Color(0xffB2D12E) : Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${selectedIndexes.length}/3 Selected",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 170),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: screen.width * 0.125,
                    height: screen.width * 0.125,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xffB2D12E), Color(0xff000000)]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onPressed: () {
                        // if (selectedInterests.isNotEmpty) {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ValuesSelectionScreen(
                        //         email: widget.email,
                        //         latitude: widget.latitude,
                        //         longitude: widget.longitude,
                        //         userName: widget.userName,
                        //         dateOfBirth: widget.dateOfBirth,
                        //         selectedGender: widget.selectedGender,
                        //         showGenderOnProfile: widget.showGenderOnProfile,
                        //         showMode: widget.showMode,
                        //         gendermode: widget.gendermode,
                        //         selectedHeight: widget.selectedHeight,
                        //         selectionOptionIds: widget.selectionOptionIds,
                        //         // selectedIntersts: selectedInterests,
                        //         selectedInterestIds: selectedInterestIds,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("Please select at least one interest")),
                        //   );
                        // }
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => AddHeadlineScreen(
                                               email: widget.email,
                                                latitude: widget.latitude,
                                                longitude: widget.longitude,
                                                userName: widget.userName,
                                                dateOfBirth: widget.dateOfBirth,
                                                selectedGender: widget.selectedGender,
                                                showGenderOnProfile: widget.showGenderOnProfile,
                                                showMode: widget.showMode,
                                                gendermode:widget.gendermode,
                                                selectionOptionIds:widget.selectionOptionIds,
                                                selectedHeight:widget.selectedHeight ,
                                                selectedInterestIds:widget.selectedInterestIds,
                                                selectedqualitiesIDs:widget.selectedqualitiesIDs,
                                                selectedhabbits: widget.selectedhabbits,
                                                selectedkids:widget.selectedkids,
                                                selectedreligions:widget.selectedreligions,
                                                selectedcauses:widget.selectedcauses,
                                                seletedprompts:widget.seletedprompts,
                                                choosedimages:widget.choosedimages,
                                                defaultmessages:selectedIndexes
                            )));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
