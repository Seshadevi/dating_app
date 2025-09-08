import 'package:dating/constants/dating_app_user.dart';
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
    final user =
        userModel.data?.isNotEmpty == true ? userModel.data![0].user : null;

    final firstName = user?.firstName?.toString() ?? 'User';
    final lastName = user?.lastName?.toString() ?? '';
    final name = '$firstName $lastName'.trim();
     final first = user?.profilePics?.first;
      print("IMAGE URL::::: $first");
    // final img = user.profilePics;
    // final imageUrl = (user?.profilePics != null && user!.profilePics!.isNotEmpty)
    //     ? user.profilePics!.first.toString()
    //     : null;
    String? imageUrl;

if (user?.profilePics != null && user!.profilePics!.isNotEmpty) {
  final first = user.profilePics!.first; // this is ProfilePics model
  if (first.url != null) {
    imageUrl = 'http://97.74.93.26:6100/${first.url!.replaceFirst(RegExp(r'^/'), '')}';
  }
}

print("IMAGE URL::::: $imageUrl");

    double profilePercent =
        0.26; // Later: calculate based on actual profile fields
    int profileDisplayPercent = (profilePercent * 100).round();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: DatingColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                decoration: 
      const BoxDecoration(
        // gradient: LinearGradient(
          // colors: [DatingColors.lightpink, DatingColors.everqpidColor],
          image:const DecorationImage(
      image: AssetImage("assets/everqpidbg.png"), // your image path
      fit: BoxFit.cover, // cover, contain, fill, etc.
    ),
          // stops: [0.0, 1.0],
          // begin: AlignmentDirectional(0.0, -1.0),
          // end: AlignmentDirectional(0, 1.0),
        // ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(
                  children: [
                    const Text('Profile',
                        style:
                            TextStyle(color: DatingColors.brown, fontSize: 22,fontWeight: FontWeight.bold)),
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
                            backgroundColor: DatingColors.mediumGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                profilePercent < 0.3
                                    ? Colors.red
                                    : Colors.pink),
                          ),
                        ),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/profileImage.jpg')
                                  ,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: DatingColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        // '$profileDisplayPercent% COMPLETE',
                        '20% COMPLETE',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                          color: DatingColors.brown,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
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
                              label: 'Settings',
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen()));
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
                                      builder: (context) =>
                                          BumbleDateProfileScreen()),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 10,
                            child: _CircleButton(
                              icon: Icons.security,
                              label: 'Safety',
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
                    const Text('HeartSync Premium',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const Text('Premium features designed to maximize your journey.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13)),
                    const SizedBox(height: 38),
                    //  Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Icon(Icons.circle,
                    //         size: 15, color: DatingColors.lightGreen),
                    //     Icon(Icons.circle,
                    //         size: 15, color: DatingColors.lightGreen),
                    //     Icon(Icons.circle,
                    //         size: 15, color: DatingColors.lightGreen),
                    //     Icon(Icons.circle,
                    //         size:const 15, color: DatingColors.lightGreen),
                    //     Icon(Icons.circle_outlined,
                    //         size: 15, color: DatingColors.primaryGreen),
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showTabBar = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DatingColors.surfaceGrey,
                        foregroundColor: DatingColors.everqpidColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                            color: DatingColors.lightpinks, // ✅ Border color
                            width: 2,                          // Border thickness
                          ),
                            ),
                            
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('Premium Plans',style: TextStyle(color:DatingColors.brown),),
                      ),
                    ),
                  ],
                ),

              // Tabs
              if (showTabBar)
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 1),
                      decoration: BoxDecoration(
                        color: DatingColors
                            .surfaceGrey, // Background color behind tabs
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color:
                              DatingColors.everqpidColor, // Active tab background
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor:
                            DatingColors.brown, // Selected tab text color
                        unselectedLabelColor: DatingColors.black,
                        indicatorPadding: EdgeInsets.zero,
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  12), // Equal padding on all sides
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
                backgroundColor: DatingColors.white,
                child: Icon(icon, color: DatingColors.brown),
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
                    color: DatingColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.black, fontSize: 11)),
      ],
    );
  }
}