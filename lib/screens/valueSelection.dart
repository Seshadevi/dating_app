import 'package:flutter/material.dart';

class ValuesSelectionScreen extends StatefulWidget {
  @override
  _ValuesSelectionScreenState createState() => _ValuesSelectionScreenState();
}

class _ValuesSelectionScreenState extends State<ValuesSelectionScreen> {
  final List<String> allQualities = [
    'Ambition', 'Empathy', 'Humour', 'Kindness', 'Openness', 'Confidence',
    'Leadership', 'Unique', 'Friends first', 'Flexible', 'Playfulness',
    'Sassiness', 'Curiosity', 'Trust Worthy'
  ];

  List<String> selectedQualities = ['Openness', 'Leadership', 'Ambition'];

  void toggleSelection(String quality) {
    setState(() {
      if (selectedQualities.contains(quality)) {
        selectedQualities.remove(quality);
      } else {
        if (selectedQualities.length < 3) {
          selectedQualities.add(quality);
        }
      }
    });
  }

  Widget _buildBubble(String text, double top, double left) {
    final isSelected = selectedQualities.contains(text);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => toggleSelection(text),
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
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
          child: Text(
            text + ' +',
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
                  // SizedBox(height: 12),
                  // Text(
                  //   'Tell Us What You\nValue In A Person',
                  //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 10),
                  Text(
                    'which qualities speak to your soul? choose 3 that would make a connection that much stronger.',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Their Qualities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            _buildBubble('Ambition', 180, 20),
            _buildBubble('Empathy', 300, 60),
            _buildBubble('Humour', 250, 150),
            _buildBubble('Kindness', 180, 230),
            _buildBubble('Openness', 350, 20),
            _buildBubble('Confidence', 450, 100),
            _buildBubble('Leadership', 400, 220),
            _buildBubble('Unique', 550, 50),
            _buildBubble('Friends first', 520, 180),
            _buildBubble('Flexible', 620, 120),
            _buildBubble('Playfulness', 650, 250),
            _buildBubble('Sassiness', 750, 60),
            _buildBubble('Curiosity', 780, 200),
            _buildBubble('Trust Worthy', 850, 130),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    '${selectedQualities.length}/3 Selected',
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
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}