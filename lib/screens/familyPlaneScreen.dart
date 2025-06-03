import 'package:flutter/material.dart';

class FamilyPlanScreen extends StatefulWidget {
  @override
  _FamilyPlanScreenState createState() => _FamilyPlanScreenState();
}

class _FamilyPlanScreenState extends State<FamilyPlanScreen> {
  Set<String> selected = {};

  void toggleSelect(String option) {
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else {
        selected.add(option);
      }
    });
  }

  Widget optionButton(String text) {
    bool isSelected = selected.contains(text);
    return GestureDetector(
      onTap: () => toggleSelect(text),
      child: Container(
        width: 130,
        height: 130,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Color(0xFF869E23), Color(0xFF000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Color(0xFFF3F7DA), Color(0xFFE6EBA4)],
                ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                
                
                // SizedBox(height: 10),
                Text(
                  "Let’s get deeper. Feel free to skip if you'd prefer not to say.",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Text(
                  "Have Kids",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    optionButton("Have Kids +"),
                    optionButton("Don’t Have\nKids ++"),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Kids",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    optionButton("Don’t Want\nKids +"),
                    optionButton("Open To\nKids +"),
                    optionButton("Want Kids +"),
                    optionButton("Not\nSure +"),
                  ],
                ),
                SizedBox(height: 80), // spacing for bottom bar
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${selected.length}/2 Selected",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Colors.green.shade700,
              //   child: Icon(Icons.arrow_forward, color: Colors.white),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
