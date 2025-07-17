import 'package:dating/screens/completeprofile/complete_profile.dart';
import 'package:dating/screens/profile_screens/insightstab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/settings/settings_page.dart';
import 'package:dating/widgets/profile_header_layout.dart';
import 'package:dating/screens/profile_screens/tabbar_content_widgets.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool showTabBar = false;

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(loginProvider);
    final user = userModel.data?.isNotEmpty == true ? userModel.data![0].user : null;

    final firstName = user?.firstName?.toString() ?? 'User';
    final lastName = user?.lastName?.toString() ?? '';
    final name = '$firstName $lastName'.trim();
    // final imageUrl = (user?.profilePics != null && user!.profilePics!.isNotEmpty)
    //     ? user.profilePics!.first.toString()
    //     : null;
   String? imageUrl;

if (user?.profilePics != null && user!.profilePics!.isNotEmpty) {
  var first = user.profilePics!.first;
  if (first is String) {
    imageUrl = 'http://97.74.93.26:6100/${first.toString().replaceFirst(RegExp(r'^/'), '')}';
  } else if (first is Map && first['url'] != null) {
    imageUrl = 'http://97.74.93.26:6100/${first['url'].toString().replaceFirst(RegExp(r'^/'), '')}';
  }
}


        print("IMAGE URL::::: $imageUrl");


    double profilePercent = 0.26; // Later: calculate based on actual profile fields
    int profileDisplayPercent = (profilePercent * 100).round();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
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
                    const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 165,
                          width: 165,
                          child: CircularProgressIndicator(
                            value: profilePercent,
                            strokeWidth: 3,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                profilePercent < 0.3 ? Colors.red : Colors.pink),
                          ),
                        ),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/profileImage.jpg') as ImageProvider,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$profileDisplayPercent% COMPLETE',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
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
                                        builder: (context) => const SettingsScreen()));
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
                                      builder: (context) => BumbleDateProfileScreen()),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 10,
                            child: _CircleButton(
                              icon: Icons.security,
                              label: 'SAFETY',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Promo section
              if (!showTabBar)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text('Heart Sync Platinum',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Level Up Every Action You Take On \nHeartsync',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 15, color: Color.fromARGB(255, 200, 232, 164)),
                        Icon(Icons.circle, size: 15, color: Color.fromARGB(255, 200, 232, 164)),
                        Icon(Icons.circle, size: 15, color: Color.fromARGB(255, 200, 232, 164)),
                        Icon(Icons.circle, size: 15, color: Color.fromARGB(255, 200, 232, 164)),
                        Icon(Icons.circle_outlined, size: 15, color: Colors.lightGreen),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('LEARN MORE'),
                      ),
                    ),
                  ],
                ),

              // Tabs
              if (showTabBar)
                Column(
                  children: [
                 Container(
  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
  decoration: BoxDecoration(
    color: const Color(0xFFF5F5F5), // Background color behind tabs
    borderRadius: BorderRadius.circular(10),
    // border: Border.all(color: Colors.grey, width: 1),
  ),
  child: TabBar(
    indicator: BoxDecoration(
      color: const Color.fromARGB(255, 128, 154, 10), // Active tab background
      borderRadius: BorderRadius.circular(10),
    ),
    labelColor: Colors.white, // Selected tab text color
    unselectedLabelColor: Colors.black87,
    indicatorPadding: EdgeInsets.zero,
    tabs: const [
      Tab(
        child: Padding(
          padding: EdgeInsets.all(12), // Equal padding on all sides
          child: Text('Pay Plan'),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('Insights Profile'),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('Safety well'),
        ),
      ),
    ],
  ),
),



                    const SizedBox(
                      height: 500,
                      child: TabBarView(
                        children: [
                          PayPlanTab(),
                          ProfileInsightsTab(),
                          SafetyTab(),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
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
                child: Icon(icon, color: const Color.fromARGB(255, 139, 135, 135)),
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
