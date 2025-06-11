import "package:flutter/material.dart";
class IntrestScreen extends StatelessWidget {
  const IntrestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Life Badges"),
      ),
      body: const Center(
        child: Text("This is the Life Badges screen"),
      ),
    );
  }
}
