import 'package:flutter/material.dart';

class LifestyleHabitsScreen extends StatefulWidget {
  @override
  _LifestyleHabitsScreenState createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends State<LifestyleHabitsScreen> {
  final List<String> selectedHabits = ['Drinking', 'Fitness Freak'];

  void toggleSelection(String habit) {
    setState(() {
      if (selectedHabits.contains(habit)) {
        selectedHabits.remove(habit);
      } else {
        if (selectedHabits.length < 5) {
          selectedHabits.add(habit);
        }
      }
    });
  }

  Widget _buildBubble(String text, double top, double left,
      {double? width, double? height}) {
    final isSelected = selectedHabits.contains(text);
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
                fontSize: text.length > 10 ? 10 : 11,
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
    return
       
        Stack(
      children: [
        // Header
        Positioned(
          top: 1,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share as much about your habits as you’re comfortable with.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Drinking',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        // EXACT bubble layout from reference
        _buildBubble('Drinking', 120, 10, width: 90, height: 90),
        _buildBubble('Smoking', 120, 110, width: 85, height: 85),
        _buildBubble('Marijuana', 100, 200, width: 95, height: 95),

        _buildBubble('Partying', 160, 290, width: 85, height: 80),
        _buildBubble('Eating Out', 200, 170, width: 95, height: 85),
        _buildBubble('Late Sleeper', 200, 60, width: 100, height: 100),

        _buildBubble('Fitness Freak', 290, 10, width: 95, height: 95),
        _buildBubble('Spiritual', 280, 140, width: 80, height: 80),
        _buildBubble('Mindfulness', 210, 250, width: 130, height: 200),

        _buildBubble('Early Riser', 380, 280, width: 75, height: 75),
        _buildBubble('Homebody', 350, 180, width: 90, height: 90),
        _buildBubble('Adventurer', 350, 90, width: 75, height: 75),

        _buildBubble('Pet Lover', 430, 110, width: 85, height: 85),
        _buildBubble('Workaholic', 400, 10, width: 90, height: 90),

        // Bottom bar
        Positioned(
          bottom: 1,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              Row(
                children: [
                  Text(
                    '${selectedHabits.length}/5 Selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                
                ],
              ),
            ],
          ),
        ),
      ],
    );
   
  }
}
