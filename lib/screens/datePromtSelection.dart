import 'package:flutter/material.dart';

class DatePromptScreen extends StatelessWidget {
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
  final List<int> selectedkids;
  final List<int> selectedreligions;
  final List<int> selectedcauses;

   DatePromptScreen({super.key,
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
    required this.selectedhabbits,
    required this.selectedkids,
    required this.selectedreligions,
    required this.selectedcauses
    });
  final List<String> prompts = [
    "First Prompt",
    "Second Prompt",
    "Third Prompt",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            "A Joy, Obviously, But Go Ahead\nAnd Answer In Your Own Words.",
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.4,fontSize: 19
            ),
          ),
          SizedBox(height: 20),
      
          // Prompt List
          ...prompts.map((prompt) => _buildPromptTile(prompt)).toList(),
      
          Spacer(),
      
          // Bottom Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0/3 Selected"),
                // CircleAvatar(
                //   radius: 24,
                //   backgroundColor: Colors.green.shade700,
                //   child: Icon(Icons.arrow_forward, color: Colors.white),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptTile(String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xFF869E23), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )
              ],
            ),
            child: Text(
              "Add",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
