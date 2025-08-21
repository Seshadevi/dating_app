import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';

class GenderPronounsFeedbackScreen extends StatefulWidget {
  const GenderPronounsFeedbackScreen({super.key});

  @override
  State<GenderPronounsFeedbackScreen> createState() =>
      _GenderPronounsFeedbackScreenState();
}

class _GenderPronounsFeedbackScreenState
    extends State<GenderPronounsFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  void _onSave() {
    String feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      // Handle feedback submission logic here
      print("Submitted Feedback: $feedback");
    }
  }

  void _onCancel() {
    Navigator.pop(context); // or clear the text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        leading: const Icon(Icons.close, color: DatingColors.black),
        backgroundColor: DatingColors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Gender Pronouns Feedback",
          style: TextStyle(color: DatingColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: DatingColors.darkGreen),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Give Me The Feedback",
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _onSave,
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DatingColors.primaryGreen, DatingColors.black],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: DatingColors.black,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Save',
                  style: TextStyle(color: DatingColors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _onCancel,
              child: const Text(
                "Cancel",
                style: TextStyle(color: DatingColors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
