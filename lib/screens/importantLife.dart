import 'package:flutter/material.dart';

class ReligionSelectionScreen extends StatefulWidget {
  @override
  _ReligionSelectionScreenState createState() => _ReligionSelectionScreenState();
}

class _ReligionSelectionScreenState extends State<ReligionSelectionScreen> {
  final List<_BubbleData> bubbleData = [
    _BubbleData("Agnostic", 20, 10),
    _BubbleData("Atheist", 160, 20),
    _BubbleData("Buddhist", 280, 5),
    _BubbleData("Hindu", 10, 100),
    _BubbleData("Christian", 120, 110),
    _BubbleData("Catholic", 10, 210),
    _BubbleData("Jewish", 180, 220),
    _BubbleData("Jain", 280, 120),
    _BubbleData("Marmon", 230, 180),
    _BubbleData("Sikh", 310, 160),
    _BubbleData("Muslim", 270, 240),
    _BubbleData("Spiritual", 80, 310),
    _BubbleData("Latter-day Saint", 160, 310),
    _BubbleData("Zoroastrian", 240, 310),
  ];

  final Set<String> selectedReligions = {};

  void toggleSelection(String religion) {
    setState(() {
      if (selectedReligions.contains(religion)) {
        selectedReligions.remove(religion);
      } else {
        selectedReligions.add(religion);
      }
    });
  }

  Widget buildBubble(String label, bool selected) {
    return GestureDetector(
      onTap: () => toggleSelection(label),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF4A6823), Color(0xFFB9D83F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey.shade200, const Color.fromARGB(255, 217, 233, 187)],
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Text(
          "$label +",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Skip", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Text(
                //   "What’s Important In\nYour Life?",
                //   style: TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     height: 1.3,
                //   ),
                // ),
                // SizedBox(height: 10),
                Text(
                  "you can answer or leave blank,\ndepending on what what matters most to you.",
                  style: TextStyle(color: Colors.grey),
                ),
                // SizedBox(height: 20),
                Text("Religion", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Stack(
              children: bubbleData.map((b) {
                bool isSelected = selectedReligions.contains(b.label);
                return Positioned(
                  left: b.left,
                  top: b.top,
                  child: buildBubble(b.label, isSelected),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text("Skip", style: TextStyle(color: Colors.black)),
            Text("${selectedReligions.length}/4 Selected"),
            // CircleAvatar(
            //   radius: 25,
            //   backgroundColor: Colors.green.shade600,
            //   child: Icon(Icons.arrow_forward, color: Colors.white),
            // )
          ],
        ),
      ),
    );
  }
}

class _BubbleData {
  final String label;
  final double left;
  final double top;

  _BubbleData(this.label, this.left, this.top);
}
