import 'package:flutter/material.dart';

class ReligionSelectorWidget extends StatefulWidget {
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
  final List<int> selectedhabbits;
  final List<int> selectedKidsIds;
  const ReligionSelectorWidget(
      {super.key,
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
  State<ReligionSelectorWidget> createState() => _ReligionSelectorWidgetState();
}

class _ReligionSelectorWidgetState extends State<ReligionSelectorWidget> {
  final List<String> selectedReligions = [];

  void toggleSelection(String label) {
    setState(() {
      if (selectedReligions.contains(label)) {
        selectedReligions.remove(label);
      } else {
        if (selectedReligions.length < 4) {
          selectedReligions.add(label);
        }
      }
    });
  }

  Widget _buildBubble(String text, double top, double left,
      {double width = 85, double height = 85}) {
    final isSelected = selectedReligions.contains(text);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => toggleSelection(text),
        child: Container(
          width: width,
          height: height,
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
                fontSize: text.length > 10 ? 10 : 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   backgroundColor: Colors.white,
        //   body:
        Stack(
      children: [
        // Header
        const Positioned(
          top: 4,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'you can answer or leave blank,\ndepending on what matters most to you.',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                'Religion',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),

        /// Religion Bubbles with Custom Positions
        _buildBubble('Hindu', 120, 10, width: 90, height: 90),
        _buildBubble('Muslim', 120, 110, width: 85, height: 85),
        _buildBubble('Christian', 100, 200, width: 95, height: 95),

        _buildBubble('Sikh', 160, 290, width: 85, height: 80),
        _buildBubble('Jain', 200, 170, width: 95, height: 85),
        _buildBubble('Buddhist', 200, 60, width: 100, height: 100),

        _buildBubble('Spiritual', 290, 10, width: 90, height: 90),
        _buildBubble('Atheist', 280, 140, width: 85, height: 85),
        _buildBubble('Agnostic', 250, 250, width: 120, height: 100),

        _buildBubble('Other', 370, 90, width: 100, height: 100),
        _buildBubble('Other', 380, 220, width: 120, height: 120),

        // Bottom Bar
        Positioned(
          bottom: 0,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Text(
              //   'Skip',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.black54,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
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
                  // CircleAvatar(
                  //   radius: 20,
                  //   backgroundColor: Colors.green.shade700,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.arrow_forward_ios,
                  //         color: Colors.white, size: 20),
                  //     onPressed: () {
                  //       // Handle navigation
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    // );
  }
}
