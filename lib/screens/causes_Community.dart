import 'package:flutter/material.dart';

class CausesScreen extends StatelessWidget {
  final List<_BubbleData> bubbles = [
    _BubbleData("Block Lives Matter +", 20, 0),
    _BubbleData("LGBTQ+ RIGHTS", 150, 20),
    _BubbleData("Feminism +", 250, 0),
    _BubbleData("Environmentalism +", 100, 100),
    _BubbleData("Disability rights +", 0, 200),
    _BubbleData("Neurodiversity +", 20, 350),
    _BubbleData("Reproductive rights +", 130, 200),
    _BubbleData("Voter rights +", 100, 280),
    _BubbleData("Human rights +", 220, 250),
    _BubbleData("Indigenous rights +", 20, 270),
    _BubbleData("Immigrant rights +", 250, 180),
    _BubbleData("End Religious Hate +", 120, 360),
    _BubbleData("Stop Asian Hate +", 250, 330),
    _BubbleData("Volunteering +", 60, 430),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leading: BackButton(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   actions: [
      //     TextButton(onPressed: () {}, child: Text("Skip", style: TextStyle(color: Colors.black)))
      //   ],
      // ),
      body: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("How About Causes\nAnd Communities?",
                //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                // SizedBox(height: 8),
                Text("choose up to 3 options close to your heart.",
                    style: TextStyle(color: Colors.grey[700])),
                // SizedBox(height: 16),
                Text("Causes And Communities",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // SizedBox(height: 16),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text("Skip", style: TextStyle(color: Colors.black)),
            Text("3/4 Selected"),
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

class _Bubble extends StatelessWidget {
  final String label;

  const _Bubble({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF869E23), Color.fromARGB(255, 66, 79, 18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))],
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color.fromARGB(255, 49, 47, 47), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
