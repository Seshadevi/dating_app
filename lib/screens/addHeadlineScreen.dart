import 'package:dating/screens/beKindScreen.dart';
import 'package:flutter/material.dart';

class AddHeadlineScreen extends StatelessWidget {
  const AddHeadlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(), // Placeholder for menu icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Ever Qupid',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                "Show Everyone\nWhat You’re Made Of",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Every Bizz Profile Needs A\nHeadline That Summarizes\nWho You Are, What You Do,\nOr What You’re Looking For.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 50, color: Color.fromARGB(255, 249, 225, 9)),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sai",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "I Work At This Company And I\nAm Looking To Connect With\nPeople In Other Industries.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: GestureDetector(
  onTap: () {
    Navigator.push(context,MaterialPageRoute(builder :(context)=>const BeKindScreen()));
  },
  child: Container(
    width: double.infinity,
    height: 55,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF869E23), Color(0xFF000000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: const Text(
      "Add Headline",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

              )
            ],
          ),
        ),
      ),
    );
  }
}
