import 'package:flutter/material.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gender On  Bumble',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Icon Image
            const Icon(Icons.wc, size: 60, color: Color(0xFF89A000)),

            const SizedBox(height: 16),

            // Top intro text
            const Text(
              'Gender is unique to each of us. And we believe every new connection starts with being able to show up as yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            // Gradient box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB1D74F), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Adding More About Your Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Designed with guidance from our friends at GLAAD, we hope the "Add More About Your Gender" option, combined with updates to give more control over who you see and who sees you, will make it easier for everyone to be themselves and find who or what they\'re looking for.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Why We\'re Committed To Inclusion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'There’s a lot to be done to enable people of all genders to show up and find new connections as their true selves. We see this as a step in the right direction to keep creating an experience that is the most supportive, inclusive, and empowering for all our members. You control how your gender shows up on your profile and can update it whenever you like. If there are more ways you’d like to see genders listed, please let us know. This experience is for you.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
