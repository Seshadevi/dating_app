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

  Widget optionButton(String text, double size, double fontSize) {
    bool isSelected = selected.contains(text);
    return GestureDetector(
      onTap: () => toggleSelect(text),
      child: Container(
        width: size,
        height: size,
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
        child: Padding(
          padding: EdgeInsets.all(size * 0.07),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final bubbleSize = screen.width * 0.3;
    final bubbleFont = screen.width * 0.035;

    return 
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     child: 
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screen.width * 0.05),
                child: ListView(
                  children: [
                    // SizedBox(height: screen.height * 0.02),
                    Text(
                      "Let’s get deeper. Feel free to skip if you'd prefer not to say.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: screen.width * 0.035,
                      ),
                    ),
                    // SizedBox(height: screen.height * 0.015),
                    Text(
                      "Have Kids",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.045,
                      ),
                    ),
                    // SizedBox(height: screen.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        optionButton("Have Kids +", bubbleSize, bubbleFont),
                        optionButton("Don’t Have\nKids ++", bubbleSize, bubbleFont),
                      ],
                    ),
                    SizedBox(height: screen.height * 0.03),
                    Text(
                      "Kids",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width * 0.045,
                      ),
                    ),
                    // SizedBox(height: screen.height * 0.015),
                    Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: screen.width * 0.02,
                      runSpacing: screen.height * 0.015,
                      children: [
                        optionButton("Don’t Want\nKids +", bubbleSize, bubbleFont),
                        optionButton("Open To\nKids +", bubbleSize, bubbleFont),
                        optionButton("Want Kids +", bubbleSize, bubbleFont),
                        optionButton("Not\nSure +", bubbleSize, bubbleFont),
                      ],
                    ),
                    // SizedBox(height: screen.height * 0.1),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screen.width * 0.05,
                vertical: screen.height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selected.length}/2 Selected",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screen.width * 0.04,
                    ),
                  ),
                  // Optional next arrow
                  // CircleAvatar(
                  //   radius: screen.width * 0.06,
                  //   backgroundColor: Colors.green.shade700,
                  //   child: Icon(Icons.arrow_forward, color: Colors.white),
                  // ),
                ],
              ),
            ),
          ],
        // ),
      // ),
    );
  }
}
