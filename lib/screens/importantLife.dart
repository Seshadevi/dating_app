import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/religionProvider.dart';
import 'package:dating/screens/causes_Community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/signupprocessmodels/religionModel.dart';

class ReligionSelectorWidget extends ConsumerStatefulWidget {
  
  const ReligionSelectorWidget({super.key,});

  @override
  ConsumerState<ReligionSelectorWidget> createState() =>
      _ReligionSelectorWidgetState();
}

class _ReligionSelectorWidgetState extends ConsumerState<ReligionSelectorWidget> {
  final List<String> selectedReligions = [];
  List<int> selectedReligionIds = [];

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
          if (args['selectedReligionIds'] != null) {
            selectedReligionIds = List<int>.from(args['selectedReligionIds']);
          }


      });
    }
  }

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(religionProvider.notifier).getReligions();
    });
  }

  void toggleSelection(String religion, int religionId) {
    setState(() {
      if (selectedReligions.contains(religion)) {
        // Remove from both lists
        int index = selectedReligions.indexOf(religion);
        selectedReligions.removeAt(index);
        selectedReligionIds.removeAt(index);
      } else {
        if (selectedReligions.length < 4) {
          // Add to both lists
          selectedReligions.add(religion);
          selectedReligionIds.add(religionId);
        }
      }
    });
  }

  Widget _buildSelectedQualitiesChips(List<Data> Data) {
    if (selectedReligions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedReligions.map((quality) {
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
                
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQualityBubble(String text, int religionId, {double? size}) {
    final isSelected = selectedReligions.contains(text);
    final bubbleSize = size ?? 80.0;
    
    return GestureDetector(
      onTap: () => toggleSelection(text, religionId),
      child: Container(
        width: bubbleSize,
        height: bubbleSize,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [DatingColors.primaryGreen,DatingColors.black],
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

  Widget _buildQualitiesGrid(List<dynamic> religionData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: religionData.map((qualityItem) {
          final religionName = qualityItem.religion.toString() ?? '';
          final religionId = (qualityItem.id as num?)?.toInt() ?? 0;
          // Vary bubble sizes for visual appeal
          double size = 70.0 + ((religionName.length % 3) * 10.0);
          return _buildQualityBubble(religionName, religionId, size: size);
        }).toList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final religionState = ref.watch(religionProvider);
    
    // Get the full qualities data (not just names)
    final religionData = religionState.data ?? [];

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
                    value: 14 / 18,
                    backgroundColor: DatingColors.white,
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
                                      "selectedKidsIds":selectedKidsIds,
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "What's Important In your Life",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Description
                  // const Text(
                  //   'you can answer or leave blank depanding \n on what matters most of you.',
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontSize: 15,
                  //   ),
                  // ),
                ],
              ),
            ),
            
            // Main content area - Expandable
            Expanded(
              child: religionState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected qualities chips
                          _buildSelectedQualitiesChips(religionData),
                          
                          // "Their Qualities" text
                          const Text(
                            'Religion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Qualities grid
                          _buildQualitiesGrid(religionData),
                          
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
                                    '/causesScreen',
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
                          '${selectedReligions.length}/1 Selected',
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
                            gradient: selectedReligions.length == 1
                                ? const LinearGradient(
                                    colors: [DatingColors.primaryGreen, DatingColors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedReligions.length != 1
                                ? DatingColors.lightgrey
                                : null,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: DatingColors.white,
                              size: 20,
                            ),
                            onPressed: () {
                                if (selectedReligions.length == 1) {
                                        
                          
                                   Navigator.pushNamed(
                                    context,
                                    '/causesScreen',
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select 1 options"))
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
  }}
