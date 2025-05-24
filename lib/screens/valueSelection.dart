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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
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
                        'Tell Us What You\nValue In A Person',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
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
                      // Qualities Bubbles
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: allQualities.map((quality) {
                            final isSelected = selectedQualities.contains(quality);
                            return GestureDetector(
                              onTap: () => toggleSelection(quality),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [Colors.green.shade700, Colors.black],
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
                                    quality + ' +',
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
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              // Bottom selection count and arrow
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
      ),
    );
  }
}
