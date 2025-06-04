import 'package:flutter/material.dart';

class PayPlanTab extends StatelessWidget {
  const PayPlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Superswipe section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillWidget("Superswipe", "0 Left", Color(0xFF869E23),
                    Color(0xFF000000)),
                const SizedBox(width: 8),
                _pillWidget("Superswipe", "1 Left",
                    Color.fromARGB(255, 203, 218, 166), Colors.black),
              ],
            ),
            const SizedBox(height: 16),

            // Premium+ Header Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 164, 178, 128),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Text(
                    'Premium+',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get The VIP Treatment, And\nEnjoy Better Ways To Connect\nWith Incredible People.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  _statusButton("Active Until 24 March 2025"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features List
            _featureList(),
          ],
        ),
      ),
    );
  }
}

// Helper widget for the pill design
Widget _pillWidget(
    String title, String subtitle, Color bgColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: TextStyle(color: textColor),
        ),
      ],
    ),
  );
}

// Active status button
class _statusButton extends StatelessWidget {
  final String text;
  const _statusButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

// Feature List with tick/check and info icon
Widget _featureList() {
  final List<String> features = [
    "Get Exclusive Photo Insights",
    "Fast Track Your Likes",
    "Stand Out Every Day",
    "Unlimited Likes",
    "See Who Liked You",
    "Advanced Filters",
    "Incognito Mode",
    "Travel Mode",
    "2 Compliments A Week",
    "10 Superswipes A Week",
    "2 Spotlights A Week",
    "Unlimited Extends",
    "Unlimited Backtrack",
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: const [
          Text("what you get:", style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text("premium +", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 12),
      for (var item in features) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(child: Text(item)),
              const Icon(Icons.check, color: Colors.black, size: 20),
            ],
          ),
        ),
      ]
    ],
  );
}

class ProfileInsightsTab extends StatelessWidget {
  const ProfileInsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How Are Your Photos Doing?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "See Which Of Your Photos Are Getting The Most Attention.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Bar Graphs
            // SizedBox(
            //   height: 100,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: List.generate(8, (index) {
            //       double height = index == 0
            //           ? 100
            //           : index == 1
            //               ? 80
            //               : index == 2
            //                   ? 60
            //                   : 30;
            //       return Container(
            //         width: 18,
            //         height: height,
            //         decoration: BoxDecoration(
            //           color: index < 3
            //               ? const Color(0xFF6A8E00)
            //               : const Color(0xFFE6F3B3),
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       );
            //     }),
            //   ),
            // ),

            // const SizedBox(height: 12),

            // // Profile Photos Row
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     for (int i = 0; i < 4; i++)
            //       const CircleAvatar(
            //         backgroundImage: AssetImage(
            //             'assets/user.png'), // Replace with your asset
            //         radius: 18,
            //       ),
            //     for (int i = 0; i < 4; i++)
            //       const CircleAvatar(
            //         radius: 18,
            //         backgroundColor: Color(0xFFE6F3B3),
            //         child: Icon(Icons.add, color: Colors.black),
            //       ),
            //   ],
            // ),
             Image.asset(
              'assets/graph_tab.png', // replace with your image asset
              height: 200,
              width: 500,
            ),

            const SizedBox(height: 16),

            const Text(
              "your latest insights",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Add photos recommendation box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF5A5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Add More Than 3 Photos To Be 43% More Likely To Get A Match.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Tips For Great Photos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Tip cards
            _tipCard(
              imagePath: 'assets/profile_insights_tab1.png',
              text: "Avoid Mirror Selfies, And Photos\nWith Filters.",
              icon: Icons.info_outline,
              iconColor: Colors.black,
            ),
            const SizedBox(height: 12),
            _tipCard(
              imagePath: 'assets/profile_insights_tab2.png',
              text:
                  "Include A Bright And Clear Photo Of Just You. Even Better If You're Smiling!",
              icon: Icons.check,
              iconColor: Colors.black,
            ),
            const SizedBox(height: 12),
            _tipCard(
              imagePath: 'assets/profile_insights_tab5.png',
              text: "Add Photos That Show Your Lifestyle And What You're Into.",
              icon: Icons.check,
              iconColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

 Widget _tipCard({
  required String imagePath,
  required String text,
  required IconData icon,
  required Color iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFDFF5A5),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE
        SizedBox(
           width: 80,
              height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Image.asset(
              imagePath,
             
              // fit: BoxFit.co,
            ),
          ),
        ),

        const SizedBox(width: 1),

        // TEXT + ICON
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Column
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 6),

              // Icon
              Icon(icon, color: iconColor),
            ],
          ),
        ),
      ],
    ),
  );
}


}

class SafetyTab extends StatelessWidget {
  const SafetyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top horizontal cards
            SizedBox(
              height: 215,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _infoCard(
                    title: "Mental Exhaustion",
                    subtitle:
                        "Help With Dating Anxiety,\nUncertainty Or Burnout",
                    imagePath: "assets/safty_bar1.png", // Replace with actual image
                    bgColor: const Color(0xFFDFF5A5),
                  ),
                  const SizedBox(width: 6),
                  _infoCard(
                    title: "Feelings Of...",
                    subtitle: "Incomplete data",
                    imagePath: "assets/safty_bar2.png", // Replace accordingly
                    bgColor: const Color(0xFFF6F5F2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Get Help Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              child: const Text(
                "Get Help From Ever Qupid",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Help options
            _helpTile(
              icon: Icons.verified_user,
              title: "Your Safety",
              subtitle: "Trusted Organisations To Help Keep You Safe And Well",
            ),
            const SizedBox(height: 12),
            _helpTile(
              icon: Icons.favorite,
              title: "Your Emotional Wellbeing",
              subtitle:
                  "Resources For A Healthy State Of Mind In Dating And In Life.",
            ),
            const SizedBox(height: 12),
            _helpTile(
              icon: Icons.gavel,
              title: "Values And Guidelines",
              subtitle:
                  "Ever Qupid See What Ever Qupid Stands For And What We Ask Of Our Community",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color bgColor,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80), // Replace with your asset
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _helpTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF5A5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.lightGreen,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
