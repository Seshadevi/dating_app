import 'package:flutter/material.dart';

class LifestyleHabitsScreen extends StatefulWidget {
  @override
  _LifestyleHabitsScreenState createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends State<LifestyleHabitsScreen> {
  List<String> selectedInterests = [];

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
    return 
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                // Align(
                //   alignment: Alignment.topRight,
                //   child: Text(
                //     'Skip',
                //     style: TextStyle(
                //       fontSize: 10,
                //       color: Colors.green.shade700,
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16),

                // // Title
                // Text(
                //   "Let’s Talk About Your\nLifestyle And Habits",
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: 8),
                Text(
                  "Share as much about your habits as you’re comfortable with.",
                  style: TextStyle(fontSize: 14, color: Colors.black87,),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10),

                Text(
                  'Drinking',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // SizedBox(height: 16),

                // Bubble cluster
                BubbleCluster(
                  selected: selectedInterests,
                  onTap: toggleInterest,
                ),

                // SizedBox(height: 40),
                Center(
                  child: Text(
                    '${selectedInterests.length}/5 Selected',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),

                // Center(
                //   child: CircleAvatar(
                //     radius: 24,
                //     backgroundColor: Colors.green.shade800,
                //     child: Icon(Icons.arrow_forward, color: Colors.white),
                //   ),
                // ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        // ),
      // ),
    );
  }
}

class BubbleCluster extends StatelessWidget {
  final List<String> selected;
  final Function(String) onTap;

  BubbleCluster({required this.selected, required this.onTap});

  final List<Map<String, dynamic>> bubbleData = [
    {'label': 'Ambition', 'top': 10.0, 'left': 20.0, 'size': 90.0},
    {'label': 'Empathy', 'top': 50.0, 'left': 120.0, 'size': 70.0},
    {'label': 'Humour', 'top': 20.0, 'left': 220.0, 'size': 80.0},
    {'label': 'openness', 'top': 110.0, 'left': 90.0, 'size': 100.0},
    {'label': 'leadership', 'top': 200.0, 'left': 10.0, 'size': 95.0},
    {'label': 'unique', 'top': 200.0, 'left': 130.0, 'size': 75.0},
    {'label': 'kindness', 'top': 60.0, 'left': 60.0, 'size': 65.0},
    {'label': 'confidence', 'top': 80.0, 'left': 220.0, 'size': 70.0},
    {'label': 'Friends first', 'top': 140.0, 'left': 210.0, 'size': 60.0},
    {'label': 'Flexible', 'top': 230.0, 'left': 230.0, 'size': 60.0},
    {'label': 'playfulness', 'top': 280.0, 'left': 60.0, 'size': 65.0},
    {'label': 'sassiness', 'top': 280.0, 'left': 140.0, 'size': 65.0},
    {'label': 'curiosity', 'top': 280.0, 'left': 220.0, 'size': 60.0},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390, // height of the bubble area
      child: Stack(
        children: bubbleData.map((bubble) {
          final isSelected = selected.contains(bubble['label']);
          return Positioned(
            top: bubble['top'],
            left: bubble['left'],
            child: GestureDetector(
              onTap: () => onTap(bubble['label']),
              child: Container(
                width: bubble['size'],
                height: bubble['size'],
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(

                          colors: [Color(0xffB2D12E), Color(0xff000000)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${bubble['label']} +',
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
        }).toList(),
      ),
    );
  }
}
