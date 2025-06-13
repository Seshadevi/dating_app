import 'package:flutter/material.dart';

class CausesScreen extends StatefulWidget {
  @override
  _CausesScreenState createState() => _CausesScreenState();
}

class _CausesScreenState extends State<CausesScreen> {
  final int maxSelection = 3;

  final List<_BubbleData> bubbles = [
    _BubbleData("Black Lives Matter+", 10, 20, 110),
    _BubbleData("LGBTQ+ RIGHTS", 10, 130, 100),
    _BubbleData("Feminism+", 10, 260, 100),
    _BubbleData("Environmentalism +", 120, 20, 110),
    _BubbleData("Jain +", 120, 130, 130),
    _BubbleData("Hindu +", 120, 280, 85),
    _BubbleData("Disability Rights +", 230, 20, 110),
    _BubbleData("Marmon +", 250, 150, 105),
    _BubbleData("Sikh +", 230, 280, 75),
    _BubbleData("Reproductive Rights +", 340, 30, 110),
    _BubbleData("Immigrant Rights +", 350, 160, 100),
    _BubbleData("Indigenous Rights +", 350, 270, 95),
    _BubbleData("Voter Rights +", 460, 40, 100),
    _BubbleData("Human Rights +", 470, 160, 95),
    _BubbleData("Neurodiversity +", 480, 260, 105),
    _BubbleData("End Religious Hate +", 580, 30, 115),
    _BubbleData("Stop Asian Hate+", 590, 180, 90),
    _BubbleData("Volunteering +", 600, 240, 100),
  ];

  final List<String> selected = [];

  void toggleSelect(String label) {
    setState(() {
      if (selected.contains(label)) {
        selected.remove(label);
      } else if (selected.length < maxSelection) {
        selected.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "choose up to 3 options close to your heart.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            "Causes And Communities",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          // const SizedBox(height: 30),

          // Bubble layout area
          // SizedBox(
          //   height: 800,
          //   child: 
             Container(
          height:  720, // Add a bit of bottom padding
          child: Stack(
            children: bubbles.map((bubble) {
              final isSelected = selected.contains(bubble.label);
              return Positioned(
                left: bubble.left,
                top: bubble.top,
                child: GestureDetector(
                  onTap: () => toggleSelect(bubble.label),
                  child: _Bubble(
                    label: bubble.label,
                    diameter: bubble.size,
                    selected: isSelected,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

          // ),

          const SizedBox(height: 20),

          // Selection count
          Row(
            children: [
              Text(
                "${selected.length}/$maxSelection Selected",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _BubbleData {
  final String label;
  final double top;
  final double left;
  final double size;

  _BubbleData(this.label, this.top, this.left, this.size);
}

class _Bubble extends StatelessWidget {
  final String label;
  final double diameter;
  final bool selected;

  const _Bubble({
    required this.label,
    required this.diameter,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF9CB230), Color(0xFF4C6D1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFD8DCC5), Color(0xFFE7E7AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(2, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
