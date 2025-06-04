import 'package:flutter/material.dart';

class ReligionSelectionScreen extends StatefulWidget {
  @override
  _ReligionSelectionScreenState createState() => _ReligionSelectionScreenState();
}

class _ReligionSelectionScreenState extends State<ReligionSelectionScreen> {
  final List<_BubbleData> bubbleData = [
    _BubbleData("Agnostic", 20, 10),
    _BubbleData("Atheist", 160, 20),
    _BubbleData("Buddhist", 280, 40),
    _BubbleData("Hindu", 30, 130),
    _BubbleData("Christian", 160, 140),
    _BubbleData("Catholic", 280, 150),
    _BubbleData("Jewish", 70, 250),
    _BubbleData("Jain", 200, 240),
    _BubbleData("Marmon", 320, 260),
    _BubbleData("Sikh", 100, 360),
    _BubbleData("Muslim", 230, 360),
    _BubbleData("Spiritual", 30, 470),
    _BubbleData("Latter-day Saint", 160, 470),
    _BubbleData("Zoroastrian", 290, 470),
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
        padding: const EdgeInsets.all(28), // Increased size
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
          boxShadow: const [
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
            fontSize: 15, // Bigger font
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
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Skip", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "you can answer or leave blank,\ndepending on what what matters most to you.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("Religion", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
          ),
          Positioned.fill(
            top: 120,
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
            Text("${selectedReligions.length}/4 Selected"),
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
