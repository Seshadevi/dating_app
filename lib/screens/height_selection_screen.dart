// import 'package:dating/constants/dating_app_user.dart';
// import 'package:dating/screens/choose_foodies.dart';
// import 'package:dating/screens/partners_selections.dart';
// import 'package:flutter/material.dart';

// class HeightSelectionScreen extends StatefulWidget {
 

//    HeightSelectionScreen({
//     super.key,
//   });

//   @override
//   State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
// }

// class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
//    String? email;
//    String? mobile;
//    double? latitude;
//    double? longitude;
//    String? dateofbirth;
//    String? userName;
//    String? selectedgender;
//    bool? showonprofile;
//    int? modeid;
//    String? modename;
//    List<String>? selectedGenderIds;
//    List<int>? selectedoptionIds;

//   int _selectedHeight = 154;
//   final int _minHeight = 120;
//   final int _maxHeight = 240;

//    @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//     if (args != null ) { // Prevent overwriting selected products
//       setState(() {
//           email= args['email'] ??'';
//           mobile = args['mobile'] ?? '';
//           latitude = args['latitude'] ?? 0.0;
//           longitude = args['longitude'] ?? 0.0;
//           dateofbirth = args['dateofbirth'] ?? '';
//           userName = args['userName'] ?? '';
//           selectedgender = args['selectgender'] ?? '';
//           showonprofile = args['showonprofile'] ?? true;
//           modeid=args['modeid'] ?? 0;
//           modename =args['modename'] ?? '';
//           selectedGenderIds=args['selectedGenderIds'] ?? [];
//           selectedoptionIds=args['selectedoptionIds'] ?? [];
//           if (args.containsKey('selectedheight') && args['selectedheight'] != null) {
//             _selectedHeight = args['selectedheight'] is int
//                 ? args['selectedheight']
//                 : int.tryParse(args['selectedheight'].toString()) ?? 154;
//           }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 40),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: LinearProgressIndicator(
//               value: 9 / 18,
//               backgroundColor: DatingColors.lightgrey,
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                   DatingColors.everqpidColor),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: () {
//                      Navigator.pushNamed(
//                                     context,
//                                     '/partnersSelection',
//                                     arguments: {
//                                       'latitude': latitude,
//                                       'longitude': longitude,
//                                       'dateofbirth':dateofbirth,
//                                       'userName':userName,
//                                       'selectgender':selectedgender,
//                                       "showonprofile":showonprofile,
//                                       "modeid":modeid,
//                                       "modename":modename,
//                                       "selectedGenderIds":selectedGenderIds,
//                                       "selectedoptionIds":selectedoptionIds,
//                                       'email':email,
//                                       'mobile':mobile
//                                     },
//                                 );
//                   }
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Let’s Talk Height",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 30, top: 20, right: 30),
//             child: Text(
//               "Quick intro now, meaningful moments later.",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: DatingColors.everqpidColor,
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 30, top: 40, bottom: 30),
//             child: Text(
//               "your height",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: DatingColors.everqpidColor,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: SizedBox(
//                 height: 300,
//                 child: HeightBubblesSelector(
//                   minValue: _minHeight,
//                   maxValue: _maxHeight,
//                   initialValue: _selectedHeight,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedHeight = value;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 24, bottom: 24),
//               child: Material(
//                 elevation: 10,
//                 borderRadius: BorderRadius.circular(50),
//                 child: Container(
//                   width: screenWidth * 0.125,
//                   height: screenWidth * 0.125,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.white),
//                     onPressed: () {
//                           // Navigator.push(...) your next screen here
//                         Navigator.pushNamed(
//                                     context,
//                                     '/interestScreen',
//                                     arguments: {
//                                       'latitude': latitude,
//                                       'longitude': longitude,
//                                       'dateofbirth':dateofbirth,
//                                       'userName':userName,
//                                       'selectgender':selectedgender,
//                                       "showonprofile":showonprofile,
//                                       "modeid":modeid,
//                                       "modename":modename,
//                                       "selectedGenderIds":selectedGenderIds,
//                                       "selectedoptionIds":selectedoptionIds,
//                                       "selectedheight":_selectedHeight,
//                                       'email':email,
//                                       'mobile':mobile
//                                     },
//                                 );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class HeightBubblesSelector extends StatefulWidget {
//   final int minValue;
//   final int maxValue;
//   final int initialValue;
//   final Function(int) onChanged;

//   const HeightBubblesSelector({
//     Key? key,
//     required this.minValue,
//     required this.maxValue,
//     required this.initialValue,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   State<HeightBubblesSelector> createState() => _HeightBubblesSelectorState();
// }

// class _HeightBubblesSelectorState extends State<HeightBubblesSelector> {
//   late ScrollController _scrollController;
//   late int _currentValue;

//   @override
//   void initState() {
//     super.initState();
//     _currentValue = widget.initialValue;
//     _scrollController = ScrollController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToIndex(_currentValue - widget.minValue);
//     });
//   }

//   void _scrollToIndex(int index) {
//     final targetOffset =
//         index * 120.0 - MediaQuery.of(context).size.width / 2 + 60;
//     _scrollController.animateTo(
//       targetOffset,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: _scrollController,
//       scrollDirection: Axis.horizontal,
//       itemCount: widget.maxValue - widget.minValue + 1,
//       itemBuilder: (context, index) {
//         final height = widget.minValue + index;
//         final isSelected = height == _currentValue;

//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               _currentValue = height;
//               widget.onChanged(_currentValue);
//             });
//             _scrollToIndex(index);
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//             child: HeightBubble(
//               height: height,
//               isSelected: isSelected,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class HeightBubble extends StatelessWidget {
//   final int height;
//   final bool isSelected;

//   const HeightBubble({
//     Key? key,
//     required this.height,
//     required this.isSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final gradient = isSelected
//         ? const LinearGradient(
//             colors: [DatingColors.primaryGreen,DatingColors.black],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )
//         : const LinearGradient(
//             colors: [DatingColors.lightyellow,DatingColors.surfaceGrey],
//           );

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isSelected ? 150 : 100,
//       height: isSelected ? 150 : 100,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: gradient,
//         boxShadow: isSelected
//             ? [
//                 BoxShadow(
//                   color: DatingColors.black.withOpacity(0.3),
//                   offset: const Offset(2, 4),
//                   blurRadius: 20,
//                 )
//               ]
//             : [],
//       ),
//       child: Center(
//         child: Text(
//           '$height cm',
//           style: TextStyle(
//             color: isSelected ? DatingColors.white : DatingColors.black,
//             fontSize: isSelected ? 18 : 14,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/choose_foodies.dart';
import 'package:dating/screens/partners_selections.dart';
import 'package:flutter/material.dart';

class HeightSelectionScreen extends StatefulWidget {
  HeightSelectionScreen({
    super.key,
  });

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
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

  int _selectedHeight = 170;
  final int _minHeight = 120;
  final int _maxHeight = 240;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        email = args['email'] ?? '';
        mobile = args['mobile'] ?? '';
        latitude = args['latitude'] ?? 0.0;
        longitude = args['longitude'] ?? 0.0;
        dateofbirth = args['dateofbirth'] ?? '';
        userName = args['userName'] ?? '';
        selectedgender = args['selectgender'] ?? '';
        showonprofile = args['showonprofile'] ?? true;
        modeid = args['modeid'] ?? 0;
        modename = args['modename'] ?? '';
        selectedGenderIds = args['selectedGenderIds'] ?? [];
        selectedoptionIds = args['selectedoptionIds'] ?? [];
        if (args.containsKey('selectedheight') && args['selectedheight'] != null) {
          _selectedHeight = args['selectedheight'] is int
              ? args['selectedheight']
              : int.tryParse(args['selectedheight'].toString()) ?? 170;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: 6/ 8,
              backgroundColor: DatingColors.lightgrey,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  DatingColors.everqpidColor),
            ),
          ),
          // const SizedBox(height: 15),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),iconSize: 30,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/intromeetgender',
                      arguments: {
                        'latitude': latitude,
                        'longitude': longitude,
                        'dateofbirth': dateofbirth,
                        'userName': userName,
                        'selectgender': selectedgender,
                        "showonprofile": showonprofile,
                        "modeid": modeid,
                        "modename": modename,
                        "selectedGenderIds": selectedGenderIds,
                        "selectedoptionIds": selectedoptionIds,
                        'email': email,
                        'mobile': mobile
                      },
                    );
                  }
                ),
                const SizedBox(width: 8),
                const Text(
                  "How Tall Are You?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.only(left: 30, top: 20, right: 30),
          //   child: Text(
          //     "Quick intro now, meaningful moments later.",
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: DatingColors.everqpidColor,
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 40, bottom: 20),
            child: Text(
              "Your Height",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DatingColors.everqpidColor,
              ),
            ),
          ),
          // Height selection with scale
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Left side scale bar
                  HeightScaleBar(
                    minHeight: _minHeight,
                    maxHeight: _maxHeight,
                    selectedHeight: _selectedHeight,
                    onHeightChanged: (height) {
                      setState(() {
                        _selectedHeight = height;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  // Right side content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Selected height display
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: DatingColors.everqpidColor.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 15,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Your Height",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: DatingColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "$_selectedHeight cm",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: DatingColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${(_selectedHeight / 30.48).toStringAsFixed(1)} ft",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: DatingColors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Height illustration
                        HeightIllustration(height: _selectedHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Continue button
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
                      colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.white),
                    onPressed: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   '/interestScreen',
                      //   arguments: {
                      //     'latitude': latitude,
                      //     'longitude': longitude,
                      //     'dateofbirth': dateofbirth,
                      //     'userName': userName,
                      //     'selectgender': selectedgender,
                      //     "showonprofile": showonprofile,
                      //     "modeid": modeid,
                      //     "modename": modename,
                      //     "selectedGenderIds": selectedGenderIds,
                      //     "selectedoptionIds": selectedoptionIds,
                      //     "selectedheight": _selectedHeight,
                      //     'email': email,
                      //     'mobile': mobile
                      //   },
                      // );
                      Navigator.pushNamed(
                          context,
                          '/defaultmessagesScreen',
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
                            "selectedheight":_selectedHeight,
                            // "selectedinterestIds":selectedinterestsIds,
                            // "selectedQualitiesIds":selectedQualitiesIds,
                            // "selectedHabbits":selectedHabitIds,
                            // "selectedKidsIds":selectedKidsIds,
                            // "selectedReligionIds":selectedReligionIds,
                            // "selectedCausesIds":selectedcausesIds,
                            'email':email,
                            'mobile':mobile
                        },
                    );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HeightScaleBar extends StatefulWidget {
  final int minHeight;
  final int maxHeight;
  final int selectedHeight;
  final Function(int) onHeightChanged;

  const HeightScaleBar({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.selectedHeight,
    required this.onHeightChanged,
  }) : super(key: key);

  @override
  State<HeightScaleBar> createState() => _HeightScaleBarState();
}

class _HeightScaleBarState extends State<HeightScaleBar> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.5; // 50% of screen height for the scale

    return Container(
      width: 80,
      height: availableHeight,
      child: Stack(
        children: [
          // Scale line
          Positioned(
            left: 30,
            child: Container(
              width: 4,
              height: availableHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DatingColors.lightgrey,
                    DatingColors.everqpidColor.withOpacity(0.5),
                    DatingColors.everqpidColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Scale markers and labels
          ...List.generate(
            ((widget.maxHeight - widget.minHeight) / 10).round() + 1,
            (index) {
              final height = widget.minHeight + (index * 10);
              final position = (height - widget.minHeight) / 
                              (widget.maxHeight - widget.minHeight) * 
                              availableHeight;
              
              return Positioned(
                top: availableHeight - position,
                child: Row(
                  children: [
                    // Scale marker
                    Container(
                      width: height % 20 == 0 ? 20 : 15, // Longer markers for every 20cm
                      height: 2,
                      color: DatingColors.everqpidColor,
                    ),
                    const SizedBox(width: 5),
                    // Height label (show every 20cm)
                    if (height % 20 == 0)
                      Text(
                        '$height',
                        style: TextStyle(
                          fontSize: 12,
                          color: DatingColors.everqpidColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          // Slider handle
          Positioned(
            top: availableHeight - 
                 ((widget.selectedHeight - widget.minHeight) / 
                  (widget.maxHeight - widget.minHeight) * availableHeight) - 15,
            left: 15,
            child: GestureDetector(
              onPanUpdate: (details) {
                final newPosition = details.localPosition.dy;
                final heightRange = widget.maxHeight - widget.minHeight;
                final newHeight = widget.maxHeight - 
                    (newPosition / availableHeight * heightRange).round();
                
                final clampedHeight = newHeight.clamp(widget.minHeight, widget.maxHeight);
                widget.onHeightChanged(clampedHeight);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DatingColors.everqpidColor.withOpacity(0.4),
                      offset: const Offset(2, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.drag_indicator,
                  color: DatingColors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeightIllustration extends StatelessWidget {
  final int height;

  const HeightIllustration({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate relative height for illustration (between 100-200 based on height range)
    final relativeHeight = ((height - 120) / (240 - 120) * 100 + 100).clamp(100.0, 200.0);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DatingColors.lightgrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Person illustration
          Container(
            width: 60,
            height: relativeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DatingColors.everqpidColor.withOpacity(0.7),
                  DatingColors.everqpidColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Head
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: DatingColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Height: ${height}cm",
            style: const TextStyle(
              fontSize: 12,
              color: DatingColors.everqpidColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}








// import 'package:dating/constants/dating_app_user.dart';
// import 'package:dating/screens/choose_foodies.dart';
// import 'package:dating/screens/partners_selections.dart';
// import 'package:flutter/material.dart';

// class HeightSelectionScreen extends StatefulWidget {
//   HeightSelectionScreen({
//     super.key,
//   });

//   @override
//   State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
// }

// class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
//   String? email;
//   String? mobile;
//   double? latitude;
//   double? longitude;
//   String? dateofbirth;
//   String? userName;
//   String? selectedgender;
//   bool? showonprofile;
//   int? modeid;
//   String? modename;
//   List<String>? selectedGenderIds;
//   List<int>? selectedoptionIds;

//   int _selectedHeight = 170;
//   final int _minHeight = 120;
//   final int _maxHeight = 240;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//     if (args != null) {
//       setState(() {
//         email = args['email'] ?? '';
//         mobile = args['mobile'] ?? '';
//         latitude = args['latitude'] ?? 0.0;
//         longitude = args['longitude'] ?? 0.0;
//         dateofbirth = args['dateofbirth'] ?? '';
//         userName = args['userName'] ?? '';
//         selectedgender = args['selectgender'] ?? '';
//         showonprofile = args['showonprofile'] ?? true;
//         modeid = args['modeid'] ?? 0;
//         modename = args['modename'] ?? '';
//         selectedGenderIds = args['selectedGenderIds'] ?? [];
//         selectedoptionIds = args['selectedoptionIds'] ?? [];
//         if (args.containsKey('selectedheight') && args['selectedheight'] != null) {
//           _selectedHeight = args['selectedheight'] is int
//               ? args['selectedheight']
//               : int.tryParse(args['selectedheight'].toString()) ?? 170;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 40),
//           // Progress bar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: LinearProgressIndicator(
//               value: 9 / 18,
//               backgroundColor: DatingColors.lightgrey,
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                   DatingColors.everqpidColor),
//             ),
//           ),
//           // Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: () {
//                     Navigator.pushNamed(
//                       context,
//                       '/partnersSelection',
//                       arguments: {
//                         'latitude': latitude,
//                         'longitude': longitude,
//                         'dateofbirth': dateofbirth,
//                         'userName': userName,
//                         'selectgender': selectedgender,
//                         "showonprofile": showonprofile,
//                         "modeid": modeid,
//                         "modename": modename,
//                         "selectedGenderIds": selectedGenderIds,
//                         "selectedoptionIds": selectedoptionIds,
//                         'email': email,
//                         'mobile': mobile
//                       },
//                     );
//                   }
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "How Tall Are You?",
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 30, top: 40, bottom: 20),
//             child: Text(
//               "Your Height",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: DatingColors.everqpidColor,
//               ),
//             ),
//           ),
//           // Enhanced Height selection with visual scaling
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: [
//                   // Left side scale bar
//                   HeightScaleBar(
//                     minHeight: _minHeight,
//                     maxHeight: _maxHeight,
//                     selectedHeight: _selectedHeight,
//                     onHeightChanged: (height) {
//                       setState(() {
//                         _selectedHeight = height;
//                       });
//                     },
//                   ),
//                   const SizedBox(width: 20),
//                   // Right side content with enhanced visuals
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Selected height display
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: DatingColors.everqpidColor.withOpacity(0.3),
//                                 offset: const Offset(0, 4),
//                                 blurRadius: 15,
//                               )
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               const Text(
//                                 "Your Height",
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: DatingColors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 "$_selectedHeight cm",
//                                 style: const TextStyle(
//                                   fontSize: 32,
//                                   color: DatingColors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 "${(_selectedHeight / 30.48).toStringAsFixed(1)} ft",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: DatingColors.white,
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         // Enhanced height illustration with scaling
//                         EnhancedHeightIllustration(
//                           height: _selectedHeight,
//                           selectedGender: selectedgender,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Continue button
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 24, bottom: 24),
//               child: Material(
//                 elevation: 10,
//                 borderRadius: BorderRadius.circular(50),
//                 child: Container(
//                   width: screenWidth * 0.125,
//                   height: screenWidth * 0.125,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios, color: DatingColors.white),
//                     onPressed: () {
//                       Navigator.pushNamed(
//                           context,
//                           '/defaultmessagesScreen',
//                           arguments: {
//                             'latitude': latitude,
//                             'longitude': longitude,
//                             'dateofbirth':dateofbirth,
//                             'userName':userName,
//                             'selectgender':selectedgender,
//                             "showonprofile":showonprofile,
//                             "modeid":modeid,
//                             "modename":modename,
//                             "selectedGenderIds":selectedGenderIds,
//                             "selectedoptionIds":selectedoptionIds,
//                             "selectedheight":_selectedHeight,
//                             'email':email,
//                             'mobile':mobile
//                         },
//                     );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class HeightScaleBar extends StatefulWidget {
//   final int minHeight;
//   final int maxHeight;
//   final int selectedHeight;
//   final Function(int) onHeightChanged;

//   const HeightScaleBar({
//     Key? key,
//     required this.minHeight,
//     required this.maxHeight,
//     required this.selectedHeight,
//     required this.onHeightChanged,
//   }) : super(key: key);

//   @override
//   State<HeightScaleBar> createState() => _HeightScaleBarState();
// }

// class _HeightScaleBarState extends State<HeightScaleBar> {
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final availableHeight = screenHeight * 0.5;

//     return Container(
//       width: 80,
//       height: availableHeight,
//       child: Stack(
//         children: [
//           // Enhanced scale line with gradient
//           Positioned(
//             left: 30,
//             child: Container(
//               width: 6,
//               height: availableHeight,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     DatingColors.lightgrey.withOpacity(0.5),
//                     DatingColors.everqpidColor.withOpacity(0.7),
//                     DatingColors.everqpidColor,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: BorderRadius.circular(3),
//                 boxShadow: [
//                   BoxShadow(
//                     color: DatingColors.everqpidColor.withOpacity(0.2),
//                     offset: const Offset(2, 0),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Scale markers and labels
//           ...List.generate(
//             ((widget.maxHeight - widget.minHeight) / 10).round() + 1,
//             (index) {
//               final height = widget.minHeight + (index * 10);
//               final position = (height - widget.minHeight) / 
//                               (widget.maxHeight - widget.minHeight) * 
//                               availableHeight;
              
//               return Positioned(
//                 top: availableHeight - position,
//                 child: Row(
//                   children: [
//                     // Enhanced scale marker
//                     Container(
//                       width: height % 20 == 0 ? 25 : 18,
//                       height: height % 20 == 0 ? 3 : 2,
//                       decoration: BoxDecoration(
//                         color: DatingColors.everqpidColor,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     // Height label with better styling
//                     if (height % 20 == 0)
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: DatingColors.everqpidColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '$height',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: DatingColors.everqpidColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           // Enhanced slider handle
//           Positioned(
//             top: availableHeight - 
//                  ((widget.selectedHeight - widget.minHeight) / 
//                   (widget.maxHeight - widget.minHeight) * availableHeight) - 20,
//             left: 10,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 final newPosition = details.localPosition.dy;
//                 final heightRange = widget.maxHeight - widget.minHeight;
//                 final newHeight = widget.maxHeight - 
//                     (newPosition / availableHeight * heightRange).round();
                
//                 final clampedHeight = newHeight.clamp(widget.minHeight, widget.maxHeight);
//                 widget.onHeightChanged(clampedHeight);
//               },
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: DatingColors.everqpidColor.withOpacity(0.4),
//                       offset: const Offset(2, 4),
//                       blurRadius: 12,
//                     ),
//                   ],
//                   border: Border.all(
//                     color: DatingColors.white,
//                     width: 3,
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.unfold_more,
//                   color: DatingColors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class EnhancedHeightIllustration extends StatelessWidget {
//   final int height;
//   final String? selectedGender;

//   const EnhancedHeightIllustration({
//     Key? key,
//     required this.height,
//     this.selectedGender,
//   }) : super(key: key);

//   String _getHeightCategory() {
//     if (height < 140) return "Very Short";
//     if (height < 160) return "Short";
//     if (height < 175) return "Average";
//     if (height < 190) return "Tall";
//     return "Very Tall";
//   }

//   Color _getHeightColor() {
//     if (height < 140) return Colors.orange;
//     if (height < 160) return Colors.amber;
//     if (height < 175) return Colors.green;
//     if (height < 190) return Colors.blue;
//     return Colors.purple;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final relativeHeight = ((height - 120) / (240 - 120) * 120 + 80).clamp(80.0, 200.0);
//     final isFemale = selectedGender?.toLowerCase().contains('female') ?? false;
//     final heightCategory = _getHeightCategory();
//     final heightColor = _getHeightColor();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             DatingColors.lightpinks.withOpacity(0.1),
//             DatingColors.everqpidColor.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: DatingColors.everqpidColor.withOpacity(0.2),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Height comparison with two figures
//           Container(
//             height: 220,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 // Background grid for reference
//                 Container(
//                   height: 220,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: _createGridPattern(),
//                       repeat: ImageRepeat.repeat,
//                       opacity: 0.1,
//                     ),
//                   ),
//                 ),
//                 // Reference person (average height)
//                 Positioned(
//                   bottom: 0,
//                   left: 30,
//                   child: _buildPersonFigure(
//                     height: 140.0, // Fixed reference height
//                     color: DatingColors.lightgrey,
//                     isSelected: false,
//                     isFemale: isFemale,
//                     label: "Average\n170cm",
//                   ),
//                 ),
//                 // Selected height person
//                 Positioned(
//                   bottom: 0,
//                   right: 30,
//                   child: _buildPersonFigure(
//                     height: relativeHeight,
//                     color: heightColor,
//                     isSelected: true,
//                     isFemale: isFemale,
//                     label: "You\n${height}cm",
//                   ),
//                 ),
//                 // Height indicator line
//                 if (relativeHeight != 140.0)
//                   Positioned(
//                     bottom: relativeHeight + 10,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 2,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             heightColor.withOpacity(0.5),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Height information card
//           Container(
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   heightColor.withOpacity(0.1),
//                   heightColor.withOpacity(0.2),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(
//                 color: heightColor.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // Column(
//                 //   children: [
//                 //     Text(
//                 //       "${height}cm",
//                 //       style: TextStyle(
//                 //         fontSize: 18,
//                 //         fontWeight: FontWeight.bold,
//                 //         color: heightColor,
//                 //       ),
//                 //     ),
//                 //     Text(
//                 //       "${(height / 30.48).toStringAsFixed(1)} ft",
//                 //       style: TextStyle(
//                 //         fontSize: 12,
//                 //         color: heightColor.withOpacity(0.8),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 Container(
//                   width: 2,
//                   height: 30,
//                   color: heightColor.withOpacity(0.3),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       heightCategory,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: heightColor,
//                       ),
//                     ),
//                     Icon(
//                       _getHeightIcon(),
//                       color: heightColor,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonFigure({
//     required double height,
//     required Color color,
//     required bool isSelected,
//     required bool isFemale,
//     required String label,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Person figure
//         Container(
//           width: isSelected ? 45 : 35,
//           height: height,
//           decoration: BoxDecoration(
//             gradient: isSelected
//                 ? LinearGradient(
//                     colors: [color.withOpacity(0.7), color],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   )
//                 : LinearGradient(
//                     colors: [color.withOpacity(0.4), color.withOpacity(0.6)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//             borderRadius: BorderRadius.circular(isSelected ? 25 : 20),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: color.withOpacity(0.3),
//                       offset: const Offset(0, 4),
//                       blurRadius: 8,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 8),
//               // Head
//               Container(
//                 width: isSelected ? 20 : 15,
//                 height: isSelected ? 20 : 15,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: DatingColors.white,
//                   border: Border.all(
//                     color: color,
//                     width: 2,
//                   ),
//                 ),
//                 child: isFemale
//                     ? Icon(
//                         Icons.face_3,
//                         size: isSelected ? 12 : 8,
//                         color: color,
//                       )
//                     : Icon(
//                         Icons.face,
//                         size: isSelected ? 12 : 8,
//                         color: color,
//                       ),
//               ),
//               // Hair for female
//               if (isFemale)
//                 Container(
//                   width: isSelected ? 25 : 20,
//                   height: isSelected ? 15 : 12,
//                   decoration: BoxDecoration(
//                     color: Colors.brown.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         // Label
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: isSelected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 10,
//               color: isSelected ? color : Colors.grey.shade600,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//               height: 1.2,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }

//   IconData _getHeightIcon() {
//     if (height < 140) return Icons.keyboard_double_arrow_down;
//     if (height < 160) return Icons.keyboard_arrow_down;
//     if (height < 175) return Icons.remove;
//     if (height < 190) return Icons.keyboard_arrow_up;
//     return Icons.keyboard_double_arrow_up;
//   }

//   ImageProvider _createGridPattern() {
//     // This would typically be an asset, but for demonstration
//     // we'll return a placeholder pattern
//     return const AssetImage('assets/images/grid_pattern.png');
//   }
// }
