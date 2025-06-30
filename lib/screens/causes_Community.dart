import 'package:dating/provider/signupprocessProviders/causesProvider.dart';
import 'package:dating/screens/datePromtSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/signupprocessmodels/causesModel.dart';

class CausesScreen extends ConsumerStatefulWidget {
  

   const CausesScreen({super.key});

  @override
  _CausesScreenState createState() => _CausesScreenState();
}

class _CausesScreenState extends ConsumerState<CausesScreen> {
  
final List<String> selectedcauses = [];
  List<int> selectedcausesIds = [];

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
   List<int>? selectedHabitIds;
   List<int>? selectedKidsIds;
   List<int>? selectedReligionIds;

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
          selectedHabitIds=args['selectedHabbits'] ?? [];
          selectedKidsIds=args['selectedKidsIds'] ?? [];
          selectedReligionIds=args['selectedReligionIds'] ?? [];
          if (args['selectedCausesIds'] != null) {
            selectedcausesIds = List<int>.from(args['selectedCausesIds']);
          }

      });
    }
  }


    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(causesProvider.notifier).getCauses();
    });
  }

  void toggleSelection(String causes, int causesId) {
    setState(() {
      if (selectedcauses.contains(causes)) {
        // Remove from both lists
        int index = selectedcauses.indexOf(causes);
        selectedcauses.removeAt(index);
        selectedcausesIds.removeAt(index);
      } else {
        if (selectedcauses.length < 4) {
          // Add to both lists
          selectedcauses.add(causes);
          selectedcausesIds.add(causesId);
        }
      }
    });
  }

  Widget _buildSelectedQualitiesChips(List<Data> Data) {
    if (selectedcauses.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedcauses.map((quality) {
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
                
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQualityBubble(String text, int causesId, {double? size}) {
    final isSelected = selectedcauses.contains(text);
    final bubbleSize = size ?? 80.0;
    
    return GestureDetector(
      onTap: () => toggleSelection(text, causesId),
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

  Widget _buildQualitiesGrid(List<dynamic> causesData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: causesData.map((qualityItem) {
          final causesName = qualityItem.causesAndCommunities.toString() ?? '';
          final causesId = (qualityItem.id as num?)?.toInt() ?? 0;
          // Vary bubble sizes for visual appeal
          double size = 70.0 + ((causesName.length % 3) * 10.0);
          return _buildQualityBubble(causesName, causesId, size: size);
        }).toList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final causesState = ref.watch(causesProvider);
    
    // Get the full qualities data (not just names)
    final causesData = causesState.data ?? [];

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
                    value: 15 / 18,
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
                        onPressed: () {
                           Navigator.pushNamed(
                                    context,
                                    '/religionScreen',
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
                                      "selectedKidsIds":selectedKidsIds,
                                      "selectedReligionIds":selectedReligionIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "How About Causes And \n Communities? ",
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
                    'choose up to 3 options close to your heart.',
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
              child: causesState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected qualities chips
                          _buildSelectedQualitiesChips(causesData),
                          
                          // "Their Qualities" text
                          const Text(
                            'Causes And Communities',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Qualities grid
                          _buildQualitiesGrid(causesData),
                          
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
                         Navigator.pushNamed(
                                    context,
                                    '/promptsScreen',
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
                                      "selectedKidsIds":selectedKidsIds,
                                      "selectedReligionIds":selectedReligionIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
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
                          '${selectedcauses.length}/4 Selected',
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
                            gradient: selectedcauses.length == 4
                                ? const LinearGradient(
                                    colors: [Color(0xFF869E23), Color(0xFF000000)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedcauses.length != 4
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
                                if (selectedcauses.length == 4) {
                                        
                          
                                   Navigator.pushNamed(
                                    context,
                                    '/promptsScreen',
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
                                      "selectedKidsIds":selectedKidsIds,
                                      "selectedReligionIds":selectedReligionIds,
                                      "selectedCausesIds":selectedcausesIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select 4 options"))
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










// import 'package:flutter/material.dart';

// class CausesScreen extends StatefulWidget {
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
//   final List<int> selectedInterestIds;
//   final List<int> selectedqualitiesIDs;
//   final List<int> selectedhabbits;
//   final List<int> selectedreligions;

//    const CausesScreen({super.key,
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
//     this.selectedHeight,
//     required this.selectedInterestIds,
//     required this.selectedqualitiesIDs,
//     required this.selectedhabbits,
//     required this.selectedreligions
//     });

//   @override
//   _CausesScreenState createState() => _CausesScreenState();
// }

// class _CausesScreenState extends State<CausesScreen> {
//   final int maxSelection = 3;

//   final List<_BubbleData> bubbles = [
//     _BubbleData("Black Lives Matter+", 10, 20, 110),
//     _BubbleData("LGBTQ+ RIGHTS", 10, 130, 100),
//     _BubbleData("Feminism+", 10, 260, 100),
//     _BubbleData("Environmentalism +", 120, 20, 110),
//     _BubbleData("Jain +", 120, 130, 130),
//     _BubbleData("Hindu +", 120, 280, 85),
//     _BubbleData("Disability Rights +", 230, 20, 110),
//     _BubbleData("Marmon +", 250, 150, 105),
//     _BubbleData("Sikh +", 230, 280, 75),
//     _BubbleData("Reproductive Rights +", 340, 30, 110),
//     _BubbleData("Immigrant Rights +", 350, 160, 100),
//     _BubbleData("Indigenous Rights +", 350, 270, 95),
//     _BubbleData("Voter Rights +", 460, 40, 100),
//     _BubbleData("Human Rights +", 470, 160, 95),
//     _BubbleData("Neurodiversity +", 480, 260, 105),
//     _BubbleData("End Religious Hate +", 580, 30, 115),
//     _BubbleData("Stop Asian Hate+", 590, 180, 90),
//     _BubbleData("Volunteering +", 600, 240, 100),
//   ];

//   final List<String> selected = [];

//   void toggleSelect(String label) {
//     setState(() {
//       if (selected.contains(label)) {
//         selected.remove(label);
//       } else if (selected.length < maxSelection) {
//         selected.add(label);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "choose up to 3 options close to your heart.",
//             style: TextStyle(color: Colors.grey, fontSize: 14),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Causes And Communities",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           // const SizedBox(height: 30),

//           // Bubble layout area
//           // SizedBox(
//           //   height: 800,
//           //   child: 
//              Container(
//           height:  720, // Add a bit of bottom padding
//           child: Stack(
//             children: bubbles.map((bubble) {
//               final isSelected = selected.contains(bubble.label);
//               return Positioned(
//                 left: bubble.left,
//                 top: bubble.top,
//                 child: GestureDetector(
//                   onTap: () => toggleSelect(bubble.label),
//                   child: _Bubble(
//                     label: bubble.label,
//                     diameter: bubble.size,
//                     selected: isSelected,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),

//           // ),

//           const SizedBox(height: 20),

//           // Selection count
//           Row(
//             children: [
//               Text(
//                 "${selected.length}/$maxSelection Selected",
//                 style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//               ),
//               const Spacer(),
//               const Icon(Icons.arrow_forward_ios, size: 16),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BubbleData {
//   final String label;
//   final double top;
//   final double left;
//   final double size;

//   _BubbleData(this.label, this.top, this.left, this.size);
// }

// class _Bubble extends StatelessWidget {
//   final String label;
//   final double diameter;
//   final bool selected;

//   const _Bubble({
//     required this.label,
//     required this.diameter,
//     required this.selected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: diameter,
//       height: diameter,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: selected
//             ? const LinearGradient(
//                 colors: [Color(0xFF9CB230), Color(0xFF4C6D1A)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : const LinearGradient(
//                 colors: [Color(0xFFD8DCC5), Color(0xFFE7E7AB)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(2, 3),
//           )
//         ],
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Center(
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 11,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
