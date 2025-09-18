import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/userdetails_socket_provider.dart';
import 'package:dating/screens/completeprofile/complete_profile.dart';
import 'package:dating/screens/profile_screens/insightstab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/settings/settings_page.dart';
import 'package:dating/screens/profile_screens/tabbar_content_widgets.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';

// ✅ also import your socket provider
// import 'package:dating/provider/socket_provider.dart'; // adjust path if needed

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

    /// ✅ Watch your socket provider here
    final meSocket = ref.watch(meRawProvider);
    print('socket users,.....$meSocket');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: DatingColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/everqpidbg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: DatingColors.brown,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// ✅ Dynamic Profile Strength Section
                    // _buildProfileStrengthSection(socketData: meSocket),
                     meSocket.when(
            loading: () => _buildProfileStrengthSection(socketData: null),
            error: (error, stack) => _buildProfileStrengthSection(socketData: null),
            data: (socketData) => _buildProfileStrengthSection(socketData: socketData),
          ),

                    // const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        color: DatingColors.brown,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                                    builder: (context) => const SettingsScreen(),
                                  ),
                                );
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
                                    builder: (context) => BumbleDateProfileScreen(),
                                  ),
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

              // Premium / TabBar content remains same ↓
              if (!showTabBar)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'HeartSync Premium',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Premium features designed to maximize your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 38),
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
                            color: DatingColors.lightpinks,
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          'Premium Plans',
                          style: TextStyle(color: DatingColors.brown),
                        ),
                      ),
                    ),
                  ],
                ),
              if (showTabBar)
                Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                      decoration: BoxDecoration(
                        color: DatingColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: DatingColors.everqpidColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: DatingColors.brown,
                        unselectedLabelColor: DatingColors.black,
                        indicatorPadding: EdgeInsets.zero,
                        tabs: const [
                          Tab(child: Padding(padding: EdgeInsets.all(12), child: Text('Pay Plan'))),
                          Tab(child: Padding(padding: EdgeInsets.all(12), child: Text('Insights Profile'))),
                          Tab(child: Padding(padding: EdgeInsets.all(12), child: Text('Safety well'))),
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
      ),
    );
  }

  /// ✅ Reuse helper widget from above
  Widget _buildProfileStrengthSection({Map<String, dynamic>? socketData}) {
    final userData = ref.watch(loginProvider);
    final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final modeId = user?.mode?.isNotEmpty == true ? user?.mode?.first.id : null;

    int profileCompletion = 0;
    String completionText = "Complete your profile";
    bool hasValidData = false;

    if (socketData != null) {
      final profileCompletionByMode = socketData['profileCompletionByMode'] as Map<String, dynamic>?;

      if (profileCompletionByMode != null && modeId != null) {
        final currentModeData = profileCompletionByMode[modeId.toString()] as Map<String, dynamic>?;

        if (currentModeData != null) {
          final percentage = currentModeData['percentage'] as int?;
          if (percentage != null && percentage > 0) {
            profileCompletion = percentage;
            final completed = currentModeData['completed'] as int? ?? 0;
            final totalRequired = currentModeData['totalRequired'] as int? ?? 0;

            completionText = "$profileCompletion% Complete ($completed/$totalRequired)";
            hasValidData = true;
          }
        }
      } else {
        final overallCompletion = socketData['profileCompletion'] as int?;
        if (overallCompletion != null && overallCompletion > 0) {
          profileCompletion = overallCompletion;
          completionText = "$profileCompletion% Complete";
          hasValidData = true;
        }
      }
    }

    Color progressColor = hasValidData && profileCompletion > 0
        ? (profileCompletion >= 80
            ? Colors.green
            : profileCompletion >= 50
                ? DatingColors.accentTeal
                : DatingColors.lightpink)
        : Colors.grey;

    // ✅ Use your imageUrl
    String? imageUrl;
    if (user?.profilePics != null && user!.profilePics!.isNotEmpty) {
      final first = user.profilePics!.first;
      if (first.imagePath != null) {
        imageUrl = 'http://97.74.93.26:6100/${first.imagePath!.replaceFirst(RegExp(r'^/'), '')}';
      }
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: progressColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 130,
              height: 130,
              child: CircularProgressIndicator(
                value: profileCompletion / 100.0,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 50, color: Colors.white);
                        },
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: progressColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$profileCompletion%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 16),
        // Text(
        //   'Profile Strength',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.w600,
        //     color: DatingColors.brown,
        //   ),
        // ),
        // const SizedBox(height: 4),
        // Text(
        //   completionText,
        //   style: TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w500,
        //     color: hasValidData ? DatingColors.brown : Colors.grey,
        //   ),
        // ),
        // const SizedBox(height: 8),
        // Text(
        //   _getMotivationalMessage(profileCompletion),
        //   style: TextStyle(fontSize: 12, color: DatingColors.lightgrey),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }

  String _getMotivationalMessage(int percentage) {
    if (percentage == 0) return "Let's get you started!";
    if (percentage < 25) return "Great start! Keep going!";
    if (percentage < 50) return "You're making great progress!";
    if (percentage < 75) return "Almost there, keep it up!";
    if (percentage < 100) return "So close to perfection!";
    return "Your profile looks amazing!";
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
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 11)),
      ],
    );
  }
}
