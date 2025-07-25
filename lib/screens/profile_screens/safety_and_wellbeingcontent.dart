import 'package:dating/screens/profile_after_click/feeling_of_rejection.dart';
import 'package:dating/screens/profile_after_click/harmful_behaviour_screen.dart';
import 'package:dating/screens/profile_after_click/irl_screen.dart';
import 'package:dating/screens/profile_after_click/mentalEhausement_screen.dart';
import 'package:flutter/material.dart';

class SafetyAndWellbeingcontent extends StatefulWidget {
  const SafetyAndWellbeingcontent({super.key});

  @override
  State<SafetyAndWellbeingcontent> createState() => _SafetyAndWellbeingcontentState();
}

class _SafetyAndWellbeingcontentState extends State<SafetyAndWellbeingcontent> {
 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(     
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Mental Exhaustion Card
              _buildHelpCard(
                icon: Icons.psychology_outlined,
                title: 'Mental Exhaustion',
                description: 'Help With Dating Anxiety Uncertainty Or Burnout',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => MentalExhaustionScreen()));
                },
              ),
              const SizedBox(height: 12),
              
              // Harmful Behavior Card
              _buildHelpCard(
                icon: Icons.warning_outlined,
                title: 'Harmful Behavior',
                description: 'What To Do About Things Like Abuse Or Catfishing',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => HarmfulBehaviorScreen()));
                },
              ),
              const SizedBox(height: 12),
              
              // Feeling Of Rejection Card
              _buildHelpCard(
                icon: Icons.sentiment_dissatisfied_outlined,
                title: 'Feeling Of Rejection',
                description: 'Overcome Low Moments Like Ghosting',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => FeelingOfRejectionScreen()));
                },
              ),
              const SizedBox(height: 12),
              
              // Bumble To IRL Card
              _buildHelpCard(
                icon: Icons.people_outline,
                title: 'Bumble To IRL',
                description: 'Tips On Staying Safe When You Decide To Date',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => BumbleToIrlScreen()));
                },
              ),
              const SizedBox(height: 24),
              
              // Get Help From Bumble Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                    ),
                     borderRadius: BorderRadius.circular(25),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Get Help From Bumble',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Your Safety Card
              _buildHelpCard(
                icon: Icons.security_outlined,
                title: 'Your Safety',
                description: 'Trusted Organization To Help Keep You Safe And Well',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  
                },
              ),
              const SizedBox(height: 12),
              
              // Your Emotional Wellbeing Card (First one)
              _buildHelpCard(
                icon: Icons.favorite_outline,
                title: 'Your Emotional Wellbeing',
                description: 'Resources For A Healthy State Of Mind Inn Dating And In Life',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  
                },
              ),
              const SizedBox(height: 12),
              
              // Your Emotional Wellbeing Card (Second one)
              _buildHelpCard(
                icon: Icons.shield_outlined,
                title: 'Your Emotional Wellbeing',
                description: 'See What Bumble Stands For And What We Ask Of Our Community',
                backgroundColor: const Color(0xFFFFF2E6),
                borderColor: const Color(0xFFFFD700),
                 onTap: () {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF333333),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.3,
                    ),
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