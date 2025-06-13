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

  Widget _buildBubble(String text, double top, double left, {double? width, double? height}) {
    final isSelected = selectedQualities.contains(text);
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => toggleSelection(text),
        child: Container(
          width: width ?? 80,
          height: height ?? 80,
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
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              text + ' +',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: text.length > 8 ? 10 : 11,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Header content
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'which qualities speak to your soul? choose 3 that would make a connection that much stronger.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Their Qualities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          
          _buildBubble('Ambition', 120, 10, width: 90, height: 90),
          _buildBubble('Empathy', 120, 110, width: 85, height: 85),
          _buildBubble('Humour', 100, 200, width: 95, height: 95),
          
          _buildBubble('Kindness', 160, 290, width: 85, height: 80),
          _buildBubble('Confidence', 200, 170, width: 95, height: 85),
          _buildBubble('Openness', 200, 60, width: 100, height: 100),
          
          _buildBubble('Leadership', 290, 10, width: 90, height: 90),
          _buildBubble('Unique', 280, 140, width: 75, height: 75),
          _buildBubble('Friends first', 210, 250, width: 130, height: 200),
          
          _buildBubble('Flexible', 380, 280, width: 70, height: 70),
          _buildBubble('Playfulness', 350, 180, width: 80, height: 80),
          _buildBubble('Sassiness', 350, 90, width: 75, height: 75),
          
          _buildBubble('Curiosity', 430, 110, width: 85, height: 85),
          _buildBubble('Trust Worthy', 400, 10, width: 90, height: 90),
          SizedBox(height: 250,),
          // Bottom section with counter and skip
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
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
                      '${selectedQualities.length}/3 Selected',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    // SizedBox(width: 10),
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: Colors.green.shade700,
                    //   child: IconButton(icon:Icon(
                    //     Icons.arrow_forward_ios,
                    //     color: Colors.white,
                    //     size: 20,),
                    //      onPressed: () { 

                    //      },
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}