import 'package:dating/provider/signupprocessProviders/religionProvider.dart';
import 'package:dating/screens/causes_Community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/signupprocessmodels/religionModel.dart';

class ReligionSelectorWidget extends ConsumerStatefulWidget {
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
  final List<int>  selectedhabbits;
  final List<int> selectedKidsIds;
  const ReligionSelectorWidget({super.key,
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
    required this.selectedqualitiesIDs,
    required this.selectedhabbits, required this.selectedKidsIds});

  @override
  ConsumerState<ReligionSelectorWidget> createState() =>
      _ReligionSelectorWidgetState();
}

class _ReligionSelectorWidgetState extends ConsumerState<ReligionSelectorWidget> {
  final List<String> selectedReligions = [];
  List<int> selectedReligionIds = [];

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
                    value: 12 / 16,
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
                          "What's Important In \n your Life",
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
                    'you can answer or leave blank\n depanding on what matters\n most of you.',
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
                          '${selectedReligions.length}/4 Selected',
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
                            gradient: selectedReligions.length == 4
                                ? const LinearGradient(
                                    colors: [Color(0xFF869E23), Color(0xFF000000)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                                : null,
                            color: selectedReligions.length != 4
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
                                if (selectedReligions.length == 4) {
                                        print("✅ Proceeding with:");
                                        print("Email: ${widget.email}");
                                        print("Lat: ${widget.latitude}, Long: ${widget.longitude}");
                                        print("Username: ${widget.userName}");
                                        print("DOB: ${widget.dateOfBirth}");
                                        print("Gender: ${widget.selectedGender}");
                                        print("Show Gender: ${widget.showGenderOnProfile}");
                                        print("Selected Mode: ${widget.showMode.value} (ID: ${widget.showMode.id})");
                                        print("Selected options: ${widget.selectionOptionIds}");
                                        print("selected height:${widget.selectedHeight}");
                                        print("selected intrests:${widget.selectedInterestIds}");
                                        print('Selected qualities IDs: ${widget.selectedqualitiesIDs}');
                                        print("selected habbits:${widget.selectedhabbits}");
                                        print("selected kids:${widget.selectedKidsIds}");
                                        print("selected religion:$selectedReligionIds");
                          
                                   // Navigator.push(...) your next screen here
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> CausesScreen(
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
                                          selectedkids:widget.selectedKidsIds,
                                          selectedreligions:selectedReligionIds
                    
                              )));
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
  }}
