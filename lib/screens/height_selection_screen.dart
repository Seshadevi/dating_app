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
              value: 9 / 18,
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
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/partnersSelection',
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
                    fontSize: 25,
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
