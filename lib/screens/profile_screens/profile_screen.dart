import 'package:dating/screens/profile_after_click/premium.dart';
import 'package:dating/screens/settings/settings_page.dart';
import 'package:dating/screens/profile_screens/tabbar_content_widgets.dart';
import 'package:dating/widgets/profile_header_layout.dart';
import 'package:flutter/material.dart';
import '../profile_screens/profile_bottomNavigationbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showTabBar = false; // Toggle for displaying TabBar

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 💚 Green Profile Header Area
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(
                  children: [
                    const Text('Profile',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 165,
                          width: 165,
                          child: CircularProgressIndicator(
                            value: 0.26,
                            strokeWidth: 3,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.pink),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              AssetImage('assets/profileImage.jpg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '26% COMPLETE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rachel, 33',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 40,
                            top: 10,
                            child: _CircleButton(
                              icon: Icons.settings,
                              label: 'SETTINGS',
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsScreen()));
                              },
                            ),
                          ),
                          Positioned(
                            top: 47,
                            child: _CircleButton(
                              icon: Icons.edit,
                              label: 'Complete Profile',
                              hasDot: true,
                              onTap: () {
                                 Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>ProfileHeaderLayout()));
                              },
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 10,
                            child: _CircleButton(
                              icon: Icons.security,
                              label: 'SAFETY',
                              onTap: () {
                               
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🟩 HeartSync Platinum Section & Learn More button (hidden when TabBar visible)
              if (!showTabBar)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Text(
                        'Heart Sync Platinum',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Level Up Every Action You Take On \nHeartsync',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle,
                              size: 15,
                              color: Color.fromARGB(255, 200, 232, 164)),
                          Icon(Icons.circle,
                              size: 15,
                              color: Color.fromARGB(255, 200, 232, 164)),
                          Icon(Icons.circle,
                              size: 15,
                              color: Color.fromARGB(255, 200, 232, 164)),
                          Icon(Icons.circle,
                              size: 15,
                              color: Color.fromARGB(255, 200, 232, 164)),
                          Icon(Icons.circle_outlined,
                              size: 15, color: Colors.lightGreen),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showTabBar = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text('LEARN MORE'),
                        ),
                      ),
                    ],
                  ),
                ),

              // 🧭 TabBar Section - Visible after button click with button style tabs
              if (showTabBar) ...[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Color.fromARGB(255, 128, 154, 10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                    tabs: [
                      Tab(text: 'Pay Plan'),
                      Tab(text: 'Profile Insights'),
                      Tab(text: 'Safety and well'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    children: [
                      PayPlanTab(),
                      ProfileInsightsTab(),
                      SafetyTab(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasDot;

  const _CircleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child:
                    Icon(icon, color: const Color.fromARGB(255, 139, 135, 135)),
              ),
            ),
            if (hasDot)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
