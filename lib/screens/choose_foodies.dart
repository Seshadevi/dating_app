import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/choosr_foodies_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/signupprocessmodels/choosefoodies_model.dart';

class InterestsScreen extends ConsumerStatefulWidget {


  const InterestsScreen({super.key,});

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  List<String> selectedInterests = [];
  List<int> selectedInterestIds = [];

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

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
          email= args['email'] ??'';
          mobile = args['mobile'] ?? '';
          latitude = args['latitude'] ?? 0.0 ;
          longitude = args['longitude'] ?? 0.0 ;
          dateofbirth = args['dateofbirth'] ?? '';
          userName = args['userName'] ?? '';
          selectedgender = args['selectgender'] ?? '';
          showonprofile = args['showonprofile'] ?? true;
          modeid=args['modeid'] ?? 0;
          modename=args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedoptionIds=args['selectedoptionIds'] ?? [];
          selectedheight=args['selectedheight'] ?? 154;
          if (args.containsKey('selectedinterestIds') && args['selectedinterestIds'] != null) {
            selectedInterestIds = List<int>.from(args['selectedinterestIds']);
          }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interestsProvider.notifier).getInterests();
    });
  }

  void toggleSelection(String interest, int interestId) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        // Remove from both lists
        int index = selectedInterests.indexOf(interest);
        selectedInterests.removeAt(index);
        selectedInterestIds.removeAt(index);
      } else {
        if (selectedInterests.length < 5) {
          // Add to both lists
          selectedInterests.add(interest);
          selectedInterestIds.add(interestId);
        }
      }
    });
  }

  Widget _buildSelectedQualitiesChips(List<Data> interestData) {
    if (selectedInterests.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedInterests.map((quality) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [DatingColors.darkGreen, DatingColors.black],
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

  Widget _buildQualityBubble(String text, int interestId, {double? size}) {
    final isSelected = selectedInterests.contains(text);
    final bubbleSize = size ?? 80.0;
    
    return GestureDetector(
      onTap: () => toggleSelection(text, interestId),
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
              color: isSelected ? DatingColors.white : DatingColors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQualitiesGrid(List<dynamic> interestData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: interestData.map((qualityItem) {
          final interestName = qualityItem.interests?.toString() ?? '';
          final interestId = (qualityItem.id as num?)?.toInt() ?? 0;
          // Vary bubble sizes for visual appeal
          double size = 70.0 + ((interestName.length % 3) * 10.0);
          return _buildQualityBubble(interestName, interestId, size: size);
        }).toList(),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    final interestState = ref.watch(interestsProvider);
    
    // Get the full qualities data (not just names)
    final interestData = interestState.data ?? [];

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
                    value: 10 / 18,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      DatingColors.darkGreen),
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
                                    '/heightscreen',
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
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Choose Five Interests",
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
                    'Foodie or climber? Add interests to find your match.',
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
              child: interestState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected qualities chips
                          _buildSelectedQualitiesChips(interestData),
                          
                          // "Their Qualities" text
                          const Text(
                            'You Might Like',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Qualities grid
                          _buildQualitiesGrid(interestData),
                          
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
                          '${selectedInterests.length}/5 Selected',
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
                            gradient: selectedInterests.length == 5
                                ? const LinearGradient(
                                    colors: [DatingColors.primaryGreen, DatingColors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedInterests.length != 5
                                ? DatingColors.surfaceGrey
                                : null,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: DatingColors.white,
                              size: 20,
                            ),
                            onPressed: () {
                                if (selectedInterests.length == 5) {

                                      
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
                                      "selectedinterestIds":selectedInterestIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select 5 options"))
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







































// import 'package:dating/provider/signupprocessProviders/choosr_foodies_provider.dart';
// import 'package:dating/screens/valueSelection.dart';
// import 'package:dating/screens/height_selection_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class InterestsScreen extends ConsumerStatefulWidget {
//   final String email;
//   final double latitude;
//   final double longitude;
//   final String userName;
//   final String dateOfBirth;
//   final String selectedGender;
//   final bool showGenderOnProfile;
//   final dynamic showMode;
//   final String? gendermode;
//   final dynamic selectedHeight;
//   final dynamic selectionOptionIds;

//   const InterestsScreen({
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
//     required this.selectedHeight,
//     this.selectionOptionIds,
//   });

//   @override
//   ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
// }

// class _InterestsScreenState extends ConsumerState<InterestsScreen> {
//   List<String> selectedInterests = [];
//   List<int> selectedInterestIds = [];

//   void toggleInterest(String interest, int id) {
//     setState(() {
//       if (selectedInterests.contains(interest)) {
//         selectedInterests.remove(interest);
//         selectedInterestIds.remove(id);
//       } else {
//         if (selectedInterests.length < 5) {
//           selectedInterests.add(interest);
//           selectedInterestIds.add(id);
//         }
//       }
//     });
//   }

//   List<Offset> generateDynamicPositions(int count) {
//     List<Offset> positions = [];
//     double startX = 20;
//     double startY = 20;
//     double gapX = 110;
//     double gapY = 110;

//     for (int i = 0; i < count; i++) {
//       double x = startX + (i % 3) * gapX + (i.isEven ? 10 : -10);
//       double y = startY + (i ~/ 3) * gapY + ((i % 3 == 0) ? 20 : 0);
//       positions.add(Offset(x, y));
//     }
//     return positions;
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => ref.read(interestsProvider.notifier).getInterests());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screen = MediaQuery.of(context).size;
//     final interestsModel = ref.watch(interestsProvider);
//     final interestsList = interestsModel.data ?? [];
//     final positions = generateDynamicPositions(interestsList.length);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     LinearProgressIndicator(
//                       value: 10 / 18,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 147, 179, 3)),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back_ios),
//                           onPressed: () => Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => HeightSelectionScreen(
//                                 email: widget.email,
//                                 latitude: widget.latitude,
//                                 longitude: widget.longitude,
//                                 userName: widget.userName,
//                                 dateOfBirth: widget.dateOfBirth,
//                                 selectedGender: widget.selectedGender,
//                                 showGenderOnProfile: widget.showGenderOnProfile,
//                                 selectionOptionIds: widget.selectionOptionIds,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ValuesSelectionScreen(
//                                 email: widget.email,
//                                 latitude: widget.latitude,
//                                 longitude: widget.longitude,
//                                 userName: widget.userName,
//                                 dateOfBirth: widget.dateOfBirth,
//                                 selectedGender: widget.selectedGender,
//                                 showGenderOnProfile: widget.showGenderOnProfile,
//                                 showMode: widget.showMode,
//                                 gendermode: widget.gendermode,
//                                 selectedHeight: widget.selectedHeight,
//                                 selectionOptionIds: widget.selectionOptionIds,
//                                 // selectedIntersts: selectedInterests,
//                                 selectedInterestIds: selectedInterestIds,
//                               ),
//                             ),
//                           ),
//                           child: const Text('Skip', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Choose Five Things\nYou Are Really Into",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'Proud foodie or big on bouldering?\nAdd interests to your profile to help you match with people who love them too.',
//                       style: TextStyle(color: Colors.black87, fontSize: screen.width * 0.04),
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEFF0D1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const TextField(
//                         decoration: InputDecoration(hintText: 'What are you into?', border: InputBorder.none),
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // Selected interests
//                     if (selectedInterests.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: selectedInterests.map((interest) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Chip(
//                                   label: Text(interest),
//                                   deleteIcon: const Icon(Icons.close),
//                                   onDeleted: () {
//                                     final index = selectedInterests.indexOf(interest);
//                                     if (index != -1) {
//                                       toggleInterest(interest, selectedInterestIds[index]);
//                                     }
//                                   },
//                                   backgroundColor: Colors.lightGreen.shade100,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),

//                     const SizedBox(height: 20),
//                     if (interestsList.isEmpty)
//                       const Center(child: Text("No interests found."))
//                     else
//                       SizedBox(
//                         height: screen.height * 0.7,
//                         child: Stack(
//                           children: List.generate(interestsList.length, (index) {
//                             final item = interestsList[index];
//                             final isSelected = selectedInterests.contains(item.interests);
//                             final pos = positions[index];

//                             return Positioned(
//                               top: pos.dy,
//                               left: pos.dx,
//                               child: GestureDetector(
//                                 onTap: () => toggleInterest(item.interests ?? '', item.id ?? 0),
//                                 child: Container(
//                                   width: 100,
//                                   height: 100,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: isSelected
//                                         ? const LinearGradient(colors: [Color(0xFF869E23), Color(0xFF000000)])
//                                         : const LinearGradient(colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)]),
//                                     boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//                                   ),
//                                   child: Text(
//                                     item.interests ?? '',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text('${selectedInterests.length}/5 Selected', style: const TextStyle(fontWeight: FontWeight.w500)),
//                         const SizedBox(width: 10),
//                         Material(
//                           elevation: 10,
//                           borderRadius: BorderRadius.circular(50),
//                           child: Container(
//                             width: screen.width * 0.125,
//                             height: screen.width * 0.125,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(colors: [Color(0xffB2D12E), Color(0xff000000)]),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//                               onPressed: () {
//                                 if (selectedInterests.isNotEmpty) {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ValuesSelectionScreen(
//                                         email: widget.email,
//                                         latitude: widget.latitude,
//                                         longitude: widget.longitude,
//                                         userName: widget.userName,
//                                         dateOfBirth: widget.dateOfBirth,
//                                         selectedGender: widget.selectedGender,
//                                         showGenderOnProfile: widget.showGenderOnProfile,
//                                         showMode: widget.showMode,
//                                         gendermode: widget.gendermode,
//                                         selectedHeight: widget.selectedHeight,
//                                         selectionOptionIds: widget.selectionOptionIds,
//                                         // selectedIntersts: selectedInterests,
//                                         selectedInterestIds: selectedInterestIds,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text("Please select at least one interest")),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

