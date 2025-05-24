import 'package:flutter/material.dart';

class InterestSelectionScreen extends StatefulWidget {
  @override
  _InterestSelectionScreenState createState() => _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final List<String> allInterests = [
    'Tennis', 'Gigs', 'Dogs', 'Writing', 'Photography',
    'Craft', 'Hiking Trips', 'Horror', 'Flexible',
    'Museums & Galleries', 'Cat', 'Gardening',
    'Caring', 'Reading', 'Fitness', 'Language'
  ];

  List<String> selectedInterests = ['Museums & Galleries'];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skip
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Title
                  Text(
                    'Choose 5 Things\nYou’re Really Into',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'proud foodie or big on bouldering? add interests to your profile to help you match with people who love them too.',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  // Search box
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'what are you into?',
                      filled: true,
                      fillColor: Color(0xFFF2F5D8),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Selected tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedInterests
                        .map((interest) => Chip(
                              backgroundColor: Colors.green.shade800,
                              label: Text(
                                interest,
                                style: TextStyle(color: Colors.white),
                              ),
                              deleteIcon: Icon(Icons.close, color: Colors.white),
                              onDeleted: () => toggleInterest(interest),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You Might Like',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  // Interests Bubbles
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: allInterests.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return GestureDetector(
                          onTap: () => toggleInterest(interest),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [Colors.green.shade800, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : LinearGradient(
                                      colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                interest + ' +',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom selection count and arrow
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    '${selectedInterests.length}/5 Selected',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6),
                  CircleAvatar(
                    backgroundColor: Colors.green.shade800,
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
