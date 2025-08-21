import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
import 'package:dating/screens/familyPlaneScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../model/signupprocessmodels/drinkingModel.dart';

class LifestyleHabitsScreen extends ConsumerStatefulWidget {
  

  const LifestyleHabitsScreen({
    super.key,
    
  });

  @override
  _LifestyleHabitsScreenState createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends ConsumerState<LifestyleHabitsScreen> {
  List<int> selectedHabitIds = [];
  List<String> selectedhabbits = [];

   String? email;
   String? mobile;
   double? latitude;
   double? longitude;
   String? dateofbirth;
   String? userName;
   String? selectedgender;
   bool? showonprofile;
   int? modeid;
   String? modename;
   List<String>? selectedGenderIds;
   List<int>? selectedoptionIds;
   int? selectedheight;
   List<int>? selectedinterestsIds;
   List<int>? selectedQualitiesIds;

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0;
          longitude = args['longitude'] ?? 0.0;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? true;
          modeid=args['modeid'] ?? 0;
          modename =args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedoptionIds=args['selectedoptionIds'] ?? [];
          selectedheight=args['selectedheight'] ?? 154;
          selectedinterestsIds=args['selectedinterestIds'] ?? [];
          selectedQualitiesIds=args['selectedQualitiesIds'] ?? [];
          if (args['selectedHabbits'] != null) {
            selectedHabitIds = List<int>.from(args['selectedHabbits']);
          }


      });
    }
  }


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
                colors: [DatingColors.primaryGreen, DatingColors.black],
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
                    color: DatingColors.white,
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
                  colors: [DatingColors.primaryGreen, DatingColors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [DatingColors.surfaceGrey, DatingColors.lightyellow,],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          boxShadow: const [
            BoxShadow(
              color: DatingColors.black,
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
              color: isSelected ? DatingColors.white : DatingColors.black,
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
      backgroundColor: DatingColors.white,
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
                    backgroundColor: DatingColors.lightgrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                       DatingColors.primaryGreen),
                  ),
                  const SizedBox(height: 15),
                  
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                           Navigator.pushNamed(
                                    context,
                                    '/qualityScreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      "modeid":modeid,
                                      "modename":modename,
                                      "selectedGenderIds":selectedGenderIds,
                                      "selectedoptionIds":selectedoptionIds,
                                      "selectedheight":selectedheight,
                                      "selectedinterestIds":selectedinterestsIds,
                                      "selectedQualitiesIds":selectedQualitiesIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Let's Talk About Your Habits",
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
                    "Share your habits — only what you’re comfortable with.",
                    style: TextStyle(
                      color: DatingColors.black,
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
                color: DatingColors.white,
                boxShadow: [
                  BoxShadow(
                    color: DatingColors.black.withOpacity(0.1),
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
                         Navigator.pushNamed(
                                    context,
                                    '/familyPlanScreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      "modeid":modeid,
                                      "modename":modename,
                                      "selectedGenderIds":selectedGenderIds,
                                      "selectedoptionIds":selectedoptionIds,
                                      "selectedheight":selectedheight,
                                      "selectedinterestIds":selectedinterestsIds,
                                      "selectedQualitiesIds":selectedQualitiesIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          color: DatingColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${selectedhabbits.length}/1 Selected',
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
                            gradient: selectedhabbits.length == 1
                                ? const LinearGradient(
                                    colors: [DatingColors.primaryGreen,DatingColors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedhabbits.length != 1
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
                              if (selectedhabbits.length == 1) {
                                

                                 Navigator.pushNamed(
                                    context,
                                    '/familyPlanScreen',
                                    arguments: {
                                      'latitude': latitude,
                                      'longitude': longitude,
                                      'dateofbirth':dateofbirth,
                                      'userName':userName,
                                      'selectgender':selectedgender,
                                      "showonprofile":showonprofile,
                                      "modeid":modeid,
                                      "modename":modename,
                                      "selectedGenderIds":selectedGenderIds,
                                      "selectedoptionIds":selectedoptionIds,
                                      "selectedheight":selectedheight,
                                      "selectedinterestIds":selectedinterestsIds,
                                      "selectedQualitiesIds":selectedQualitiesIds,
                                      "selectedHabbits":selectedHabitIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select 1 options")),
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
