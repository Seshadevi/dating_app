import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
import 'package:dating/screens/familyPlaneScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../model/signupprocessmodels/drinkingModel.dart';

class LifestyleHabitsScreen extends ConsumerStatefulWidget {
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

  const LifestyleHabitsScreen({
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
    required this.selectedqualitiesIDs
  });

  @override
  _LifestyleHabitsScreenState createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends ConsumerState<LifestyleHabitsScreen> {
  List<int> selectedHabitIds = [];
  List<String> selectedhabbits = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drinkingProvider.notifier).getdrinking();
    });
  }

  void toggleSelection(String habit,int habitId) {
    setState(() {
      if (selectedhabbits.contains(habit)) {
         int index = selectedhabbits.indexOf(habit);
        selectedhabbits.removeAt(index);
        selectedHabitIds.removeAt(index);
     
      } else {
        if (selectedHabitIds.length < 5) {
          selectedhabbits.add(habit);
          selectedHabitIds.add(habitId);
        }
      }
    });
  }

   Widget _buildSelectedQualitiesChips(List<Data> drinkingData) {
    if (selectedhabbits.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedhabbits.map((quality) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF869E23), Color(0xFF000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quality,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                // GestureDetector(
                //   onTap: () {
                //     // Find the quality ID from the qualities list
                //     // final qualitiesData = qualitiesState.data ?? [];
                //     final qualityItem = qualitiesData.firstWhereOrNull(
                //       (item) => item.name?.toString() == quality,
                //       // orElse: () => null,
                //     );
                //     if (qualityItem != null) {
                //       final qualityId = (qualityItem.id as num?)?.toInt() ?? 0;
                //       toggleSelection(quality, qualityId);
                //     }
                //   },
                //   child: const Icon(
                //     Icons.close,
                //     color: Colors.white,
                //     size: 16,
                //   ),
                // ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQualityBubble(String text, int habbitId, {double? size}) {
    final isSelected = selectedhabbits.contains(text);
    final bubbleSize = size ?? 80.0;
    
    return GestureDetector(
      onTap: () => toggleSelection(text, habbitId),
      child: Container(
        width: bubbleSize,
        height: bubbleSize,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF869E23), Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '$text +',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: text.length > 8 ? 10 : 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQualitiesGrid(List<dynamic> drinkingData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: drinkingData.map((drinkingItem) {
          final drinkingName = drinkingItem.preference?.toString() ?? '';
          final drinkingId = (drinkingItem.id as num?)?.toInt() ?? 0;
          // Vary bubble sizes for visual appeal
          double size = 70.0 + ((drinkingName.length % 3) * 10.0);
          return _buildQualityBubble(drinkingName, drinkingId, size: size);
        }).toList(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final drinkingState = ref.watch(drinkingProvider);
    
    // Get the full qualities data (not just names)
    final drinkingData = drinkingState.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: 12 / 18,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 147, 179, 3)),
                  ),
                  const SizedBox(height: 15),
                  
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Let's Talk About Your Life\nStyle And Habits",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Description
                  const Text(
                    "share as much about your habits as you're\n habits as you're comfortable\n with",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content area - Expandable
            Expanded(
              child: drinkingState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected qualities chips
                          _buildSelectedQualitiesChips(drinkingData),
                          
                          // "Their Qualities" text
                          const Text(
                            'Drinking',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Qualities grid
                          _buildQualitiesGrid(drinkingData),
                          
                          // Bottom padding to ensure content isn't hidden behind bottom section
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
            
           // Bottom section - Fixed
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle skip action
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${selectedhabbits.length}/5 Selected',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Gradient button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: selectedhabbits.length == 5
                                ? const LinearGradient(
                                    colors: [Color(0xFF869E23), Color(0xFF000000)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedhabbits.length != 5
                                ? Colors.grey.shade400
                                : null,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              if (selectedhabbits.length == 5) {
                                print("✅ Proceeding with:");
                                print("Email: ${widget.email}");
                                print("Lat: ${widget.latitude}, Long: ${widget.longitude}");
                                print("Username: ${widget.userName}");
                                print("DOB: ${widget.dateOfBirth}");
                                print("Gender: ${widget.selectedGender}");
                                print("Show Gender: ${widget.showGenderOnProfile}");
                                print("Selected Mode: ${widget.showMode.value} (ID: ${widget.showMode.id})");
                                print("Selected options: ${widget.selectionOptionIds}");
                                print("selected intrests:${widget.selectedInterestIds}");
                                print('Selected qualities IDs: ${widget.selectedqualitiesIDs}');
                                print("selected habbits:$selectedHabitIds");

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FamilyPlanScreen(
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
                                      selectedqualitiesIDs: widget.selectedqualitiesIDs,
                                      selectedhabbits: selectedHabitIds,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select 5 options")),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}






// import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LifestyleHabitsScreen extends ConsumerStatefulWidget {
//   final String email;
//   final double latitude;
//   final double longitude;
//   final String userName;
//   final String dateOfBirth;
//   final String selectedGender;
//   final bool showGenderOnProfile;
//   final showMode;
//   final String? gendermode;
//   final dynamic selectionOptionIds;
//   final dynamic selectedHeight;
//   final List<String> selectedintrests;
//   final List<int> selectedqualitiesIDs;

//   const LifestyleHabitsScreen({
//     super.key,
//     required this.email,
//     required this.latitude,
//     required this.longitude,
//     required this.userName,
//     required this.dateOfBirth,
//     required this.selectedGender,
//     required this.showGenderOnProfile,
//     this.showMode,
//     this.gendermode,
//     this.selectionOptionIds,
//      this.selectedHeight,
//     required this.selectedintrests,
//     required this.selectedqualitiesIDs
//   });

//   @override
//   _LifestyleHabitsScreenState createState() => _LifestyleHabitsScreenState();
// }

// class _LifestyleHabitsScreenState extends ConsumerState<LifestyleHabitsScreen> {
//   final List<String> selectedHabits = ['Drinking', 'Fitness Freak'];

//     @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(drinkingProvider.notifier).getdrinking();
//     });
//   }

//   void toggleSelection(String habit) {
//     setState(() {
//       if (selectedHabits.contains(habit)) {
//         selectedHabits.remove(habit);
//       } else {
//         if (selectedHabits.length < 5) {
//           selectedHabits.add(habit);
//         }
//       }
//     });
//   }

//   Widget _buildBubble(String text, double top, double left,
//       {double? width, double? height}) {
//     final isSelected = selectedHabits.contains(text);
//     return Positioned(
//       top: top,
//       left: left,
//       child: GestureDetector(
//         onTap: () => toggleSelection(text),
//         child: Container(
//           width: width ?? 80,
//           height: height ?? 80,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: isSelected
//                 ? LinearGradient(
//                     colors: [Color(0xFF869E23), Color(0xFF000000)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   )
//                 : LinearGradient(
//                     colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(2, 2),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: Text(
//               text + ' +',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: text.length > 10 ? 10 : 11,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.white : Colors.black87,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final drinkings =ref.read(drinkingProvider).data ??[];
//     return
       
//         Stack(
//       children: [
//         // Header
//         Positioned(
//           top: 1,
//           left: 20,
//           right: 20,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Share as much about your habits as you’re comfortable with.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 'Drinking',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // EXACT bubble layout from reference
//         _buildBubble('Drinking', 120, 10, width: 90, height: 90),
//         _buildBubble('Smoking', 120, 110, width: 85, height: 85),
//         _buildBubble('Marijuana', 100, 200, width: 95, height: 95),

//         _buildBubble('Partying', 160, 290, width: 85, height: 80),
//         _buildBubble('Eating Out', 200, 170, width: 95, height: 85),
//         _buildBubble('Late Sleeper', 200, 60, width: 100, height: 100),

//         _buildBubble('Fitness Freak', 290, 10, width: 95, height: 95),
//         _buildBubble('Spiritual', 280, 140, width: 80, height: 80),
//         _buildBubble('Mindfulness', 210, 250, width: 130, height: 200),

//         _buildBubble('Early Riser', 380, 280, width: 75, height: 75),
//         _buildBubble('Homebody', 350, 180, width: 90, height: 90),
//         _buildBubble('Adventurer', 350, 90, width: 75, height: 75),

//         _buildBubble('Pet Lover', 430, 110, width: 85, height: 85),
//         _buildBubble('Workaholic', 400, 10, width: 90, height: 90),

//         // Bottom bar
//         Positioned(
//           bottom: 1,
//           left: 20,
//           right: 20,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
             
//               Row(
//                 children: [
//                   Text(
//                     '${selectedHabits.length}/5 Selected',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
                
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
   
//   }
// }
