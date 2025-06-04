import 'package:flutter/material.dart';

class CausesScreen extends StatelessWidget {
  final List<_BubbleData> bubbles = [
    _BubbleData("Black Lives Matter", 20, 0),
    _BubbleData("LGBTQ+ RIGHTS", 150, 20),
    _BubbleData("Feminism", 250, 0),
    _BubbleData("Environmentalism", 100, 100),
    _BubbleData("Disability rights", 0, 200),
    _BubbleData("Neurodiversity", 20, 350),
    _BubbleData("Reproductive rights", 130, 200),
    _BubbleData("Voter rights", 100, 280),
    _BubbleData("Human rights", 220, 250),
    _BubbleData("Indigenous rights", 20, 270),
    _BubbleData("Immigrant rights", 250, 180),
    _BubbleData("End Religious Hate", 120, 360),
    _BubbleData("Stop Asian Hate", 250, 330),
    _BubbleData("Volunteering", 60, 430),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "choose up to 3 options close to your heart.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "Causes And Communities",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: bubbles
                .map((bubble) => Positioned(
                      left: bubble.left,
                      top: bubble.top,
                      child: _Bubble(label: bubble.label),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _BubbleData {
  final String label;
  final double left;
  final double top;

  _BubbleData(this.label, this.left, this.top);
}

class _Bubble extends StatelessWidget {
  final String label;

  const _Bubble({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          colors: [Color(0xFF9CB230), Color(0xFF4C6D1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
