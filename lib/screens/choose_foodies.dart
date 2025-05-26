import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<String> selectedInterests = ['Museums & Galleries'];
  final List<String> allInterests = [
    'Tennis', 'Gigs', 'Dogs', 'Craft', 'Hiking Trips', 'Writing',
    'Photography', 'Museums & Galleries', 'Cat', 'Gardening',
    'Caring', 'Reading', 'Fitness', 'Horror', 'Language', 'Flexible'
  ];

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 10,
                          color:Color(0xFF869E23),
                        ),
                      ),
                    ),
                    Text(
                      'Proud foodie or big on\nbouldering? Add interests to your profile to help you match with people who love them too.',
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF0D1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'what are you into?',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: selectedInterests
                          .map(
                            (interest) => Chip(
                              label: Text(
                                interest,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor:Color(0xFF869E23),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'You Might Like',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 400,
                      child: Stack(
                        children: [
                          _buildBubble('Tennis', 30, 20),
                          _buildBubble('Gigs', 100, 100),
                          _buildBubble('Dogs', 200, 50),
                          _buildBubble('Craft', 80, 180),
                          _buildBubble('Hiking Trips', 180, 160),
                          _buildBubble('Writing', 50, 270),
                          _buildBubble('Photography', 160, 250),
                          _buildBubble('Museums & Galleries', 240, 120),
                          _buildBubble('Cat', 270, 30),
                          _buildBubble('Gardening', 280, 200),
                          _buildBubble('Caring', 20, 350),
                          _buildBubble('Reading', 180, 330),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
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
                    backgroundColor:Color(0xFF869E23), 
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

  Widget _buildBubble(String interest, double top, double left) {
    final isSelected = selectedInterests.contains(interest);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => toggleInterest(interest),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected
                ? LinearGradient(
                    colors: [Color(0xFF869E23), Color(0xFF000000)],
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
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              interest,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}