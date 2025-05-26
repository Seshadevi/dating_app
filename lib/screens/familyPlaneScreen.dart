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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: Icon(Icons.arrow_back, color: Colors.black),
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: Text("Skip", style: TextStyle(color: Colors.black)),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            // SizedBox(height: 10),
            // Text(
            //   "Do You Have Kids  Or\nFamily Plans?",
            //   style: TextStyle(
            //       fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
            // ),
            // SizedBox(height: 10),
            Text(
              "let’s get deeper. feel free to skip if you'd prefer not to say.",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            Text("Have Kids", style: TextStyle(fontWeight: FontWeight.bold)),
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                optionButton("Have Kids +"),
                optionButton("Don’t Have\nKids ++"),
              ],
            ),
            SizedBox(height: 10),
            Text("Kids", style: TextStyle(fontWeight: FontWeight.bold)),
            // SizedBox(height: 5),
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
            // SizedBox(height: 5),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text("Skip", style: TextStyle(color: Colors.black)),
            Text("${selected.length}/2 Selected"),
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
