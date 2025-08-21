import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/signupprocessProviders/qualities.dart';
import 'package:dating/screens/lifeStryle_habits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/signupprocessmodels/qualitiesModel.dart';
import 'package:collection/collection.dart';



class ValuesSelectionScreen extends ConsumerStatefulWidget {
  const ValuesSelectionScreen({super.key,});

  @override
  _ValuesSelectionScreenState createState() => _ValuesSelectionScreenState();
}

class _ValuesSelectionScreenState extends ConsumerState<ValuesSelectionScreen> {
  List<String> selectedQualities = [];
  List<int> selectedQualitiesIds = [];

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
          modename =args['modename'] ?? '';
          selectedGenderIds=args['selectedGenderIds'] ?? [];
          selectedoptionIds=args['selectedoptionIds'] ?? [];
          selectedheight=args['selectedheight'] ?? 154;
          selectedinterestsIds=args['selectedinterestIds'] ?? [];
          if (args['selectedQualitiesIds'] != null) {
            selectedQualitiesIds = List<int>.from(args['selectedQualitiesIds']);
          }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(qualitiesProvider.notifier).getQualities();
    });
  }

  void toggleSelection(String quality, int qualityId) {
    setState(() {
      if (selectedQualities.contains(quality)) {
        // Remove from both lists
        int index = selectedQualities.indexOf(quality);
        selectedQualities.removeAt(index);
        selectedQualitiesIds.removeAt(index);
      } else {
        if (selectedQualities.length < 4) {
          // Add to both lists
          selectedQualities.add(quality);
          selectedQualitiesIds.add(qualityId);
        }
      }
    });
  }

  Widget _buildSelectedQualitiesChips(List<Data> qualitiesData) {
    if (selectedQualities.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedQualities.map((quality) {
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

  Widget _buildQualityBubble(String text, int qualityId, {double? size}) {
    final isSelected = selectedQualities.contains(text);
    final bubbleSize = size ?? 80.0;
    
    return GestureDetector(
      onTap: () => toggleSelection(text, qualityId),
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

  Widget _buildQualitiesGrid(List<dynamic> qualitiesData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: qualitiesData.map((qualityItem) {
          final qualityName = qualityItem.name?.toString() ?? '';
          final qualityId = (qualityItem.id as num?)?.toInt() ?? 0;
          // Vary bubble sizes for visual appeal
          double size = 70.0 + ((qualityName.length % 3) * 10.0);
          return _buildQualityBubble(qualityName, qualityId, size: size);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qualitiesState = ref.watch(qualitiesProvider);
    
    // Get the full qualities data (not just names)
    final qualitiesData = qualitiesState.data ?? [];

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
                    value: 11 / 18,
                    backgroundColor: DatingColors.white,
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
                                    '/interestScreen',
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
                                      'email':email,
                                      'mobile':mobile
                                    },
                                );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Tell Us What You Value In \n A Person",
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
                    'Choose 4 that define your kind of connection.',
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
              child: qualitiesState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected qualities chips
                          _buildSelectedQualitiesChips(qualitiesData),
                          
                          // "Their Qualities" text
                          const Text(
                            'Their Qualities',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Qualities grid
                          _buildQualitiesGrid(qualitiesData),
                          
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
                                    '/habbitsScreen',
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
                          '${selectedQualities.length}/4 Selected',
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
                            gradient: selectedQualities.length == 4
                                ? const LinearGradient(
                                    colors: [DatingColors.primaryGreen, DatingColors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedQualities.length != 4
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
                                if (selectedQualities.length == 4) {
                                     
                                      
                          
                                   Navigator.pushNamed(
                                    context,
                                    '/habbitsScreen',
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