import "package:dating/constants/dating_app_user.dart";
import "package:dating/provider/loginProvider.dart";
import "package:dating/provider/userdetails_socket_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";


class ProfileStrengthDetailScreen extends ConsumerStatefulWidget {
  const ProfileStrengthDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileStrengthDetailScreen> createState() => _ProfileStrengthDetailScreenState();
}

class _ProfileStrengthDetailScreenState extends ConsumerState<ProfileStrengthDetailScreen> {
 // Replace your _buildProfileStrengthSection method with this:

Widget _buildProfileStrengthSection({Map<String, dynamic>? socketData}) {
  final userData = ref.watch(loginProvider);
  final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
  final modeId = user?.mode?.isNotEmpty == true ? user?.mode?.first.id : null;

  // Extract profile completion data from socket
  int profileCompletion = 0;
  String completionText = "Complete your profile";
  bool hasValidData = false;
  
  if (socketData != null) {
    // Get mode-specific completion data first (prioritize mode-specific data)
    final profileCompletionByMode = socketData['profileCompletionByMode'] as Map<String, dynamic>?;
    
    if (profileCompletionByMode != null && modeId != null) {
      // Get data for current mode using modeId as string key
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
      // Fallback to overall completion if mode-specific data not available
      final overallCompletion = socketData['profileCompletion'] as int?;
      if (overallCompletion != null && overallCompletion > 0) {
        profileCompletion = overallCompletion;
        completionText = "$profileCompletion% Complete";
        hasValidData = true;
      }
    }
  }

  // Determine progress color based on completion percentage
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
      // Circular Profile Picture with Progress Ring
      Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
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
          // Progress Ring
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
          // Profile Picture
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
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
          // Percentage Badge
          Positioned(
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: progressColor.withOpacity(0.3),
                    blurRadius: 0,
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
      const SizedBox(height: 10),
      
      // Profile Strength Text and Subtitle
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
      //     color: hasValidData ? DatingColors.everqpidColor : Colors.grey,
      //   ),
      // ),
      // const SizedBox(height: 8),
      
      // Motivational message based on completion
      Text(
        _getMotivationalMessage(profileCompletion),
        style: TextStyle(
          fontSize: 12,
          color: DatingColors.lightgrey,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

// Add this helper method to your class:
String _getMotivationalMessage(int percentage) {
  if (percentage == 0) return "Let's get you started!";
  if (percentage < 25) return "Great start! Keep going!";
  if (percentage < 50) return "You're making great progress!";
  if (percentage < 75) return "Almost there, keep it up!";
  if (percentage < 100) return "So close to perfection!";
  return "Your profile looks amazing!";
}
  @override
  Widget build(BuildContext context) {
    final userData = ref.read(loginProvider);
    final user = userData.data?.isNotEmpty == true ? userData.data![0].user : null;
    final modeId = user?.mode?.isNotEmpty == true ? user?.mode?.first.id : null;
    final modeName = user?.mode?.isNotEmpty == true ? user?.mode?.first.value : '';
    final meSocket = ref.watch(meRawProvider);
  print('socket users,.....$meSocket');


    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor:DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DatingColors.everqpidColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Strength',
          style: TextStyle(
            color: DatingColors.brown,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile circle with percentage
            meSocket.when(
            loading: () => _buildProfileStrengthSection(socketData: null),
            error: (error, stack) => _buildProfileStrengthSection(socketData: null),
            data: (socketData) => _buildProfileStrengthSection(socketData: socketData),
          ),
            const SizedBox(height: 30),
            
            // Title and subtitle
            const Text(
              'Build Your Profile With Your Favorites',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DatingColors.everqpidColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'It\'s Quick To Set Up And Will Boost Your Chances Of Matching',
              style: TextStyle(
                fontSize: 14,
                color: DatingColors.lightgrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Profile cards grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
               if (user?.headLine == null || user!.headLine!.isEmpty) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/completeprofile',
                                arguments: 'bio_section',
                              );
                            },
                            child: _buildProfileCard(
                              icon: Icons.person,
                              title: 'Bio',
                              subtitle: '',
                              isCompleted: false,
                              iconColor: DatingColors.brown,
                            ),
                          ),
                        ],

                                        // if (user?.headLine == null || user! == false) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/completeprofile',
                                arguments: 'getverify_section',
                              );
                            },
                            child: _buildProfileCard(
                              icon: Icons.verified_user_outlined,
                              title: 'Get Verified',
                              subtitle: 'Not Verified',
                              isCompleted: false,
                              iconColor: DatingColors.brown,
                            ),
                          ),
                        // ],

                                      if ((user?.work == null ) &&
                            (user?.education == null ) &&
                            user?.gender == null &&
                            (user?.location == null ) &&
                            (user?.hometown == null || user!.hometown!.isEmpty)) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/completeprofile',
                                arguments: 'about_section',
                              );
                            },
                            child: _buildProfileCard(
                              icon: Icons.person,
                              title: 'About',
                              subtitle: '',
                              isCompleted: false,
                              iconColor: DatingColors.brown,
                            ),
                          ),
                        ],

                                        // if ((modeId == 4 || modeId == 5||modeId==6) && user?.height == null&&user?.lookingFor==null&&user?.relationships==null&&user?.kids==null&&user?.smoking==null&&user?.drinking==null&&user?.exercise==null&&user?.newToArea==null&&user?.starSign==null&&user?.religions==null&&user?.haveKids==null)...[
                                      if ((modeId == 4 || modeId == 5 || modeId == 6) &&
                            (
                              user?.height == null ||
                              (user?.lookingFor == null || user!.lookingFor!.isEmpty) ||
                              (user.relationships == null || user.relationships!.isEmpty) ||
                              (user.kids == null || user.kids!.isEmpty) ||
                              (user.smoking == null || user.smoking!.isEmpty) ||
                              (user.drinking == null || user.drinking!.isEmpty) ||
                              (user.exercise == null || user.exercise!.isEmpty) ||
                              (user.newToArea == null || user.newToArea!.isEmpty) ||
                              user.starSign == null ||
                              (user.religions == null || user.religions!.isEmpty) ||
                              (user.haveKids == null || user.haveKids!.isEmpty)
                            )
                        ) ...[
                                        

                                        GestureDetector(
                                          onTap: (){

                                          
                                          Navigator.pushReplacementNamed(
                                                  context,
                                                  '/completeprofile',
                                                  arguments: 'moreabout_section', // 👈 pass the section you want
                                                );
                                          },
                                          child: _buildProfileCard(
                                            icon: Icons.info_outline,
                                            title: 'More About',
                                            subtitle: '',
                                            isCompleted: false,
                                            iconColor: DatingColors.brown,
                                            hasMoreInfo: true,
                                          ),
                                        ),
                                        ],
                                        if(user?.profilePics==null&&user!.profilePics!.isEmpty)...[
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushReplacementNamed(
                                                  context,
                                                  '/completeprofile',
                                                  arguments: 'photos_section', // 👈 pass the section you want
                                                );
                                          },
                                          child: _buildProfileCard(
                                            icon: Icons.photo_library_outlined,
                                            title: 'Photos',
                                            subtitle: '',
                                            isCompleted: false,
                                            iconColor: DatingColors.brown,
                                          ),
                                        ),
                                        ],
                                        if(user?.prompts==null&&user!.prompts!.isEmpty)...[
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushReplacementNamed(
                                                  context,
                                                  '/completeprofile',
                                                  arguments: 'prompts_section', // 👈 pass the section you want
                                                );
                                          },
                                          child: _buildProfileCard(
                                            icon: Icons.chat_bubble_outline,
                                            title: 'Prompts',
                                            subtitle: '',
                                            isCompleted: false,
                                            iconColor: DatingColors.brown,
                                          ),
                                        ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    
                                    // Interests card (single width)
                                  if ((modeId == 4 || modeId == 5) &&
                            (user?.interests == null || user!.interests!.isEmpty)) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/completeprofile',
                                arguments: 'Interest_section',
                              );
                            },
                            child: _buildSingleProfileCard(
                              icon: Icons.interests_outlined,
                              title: 'Interests',
                              subtitle: '',
                              isCompleted: false,
                              iconColor: DatingColors.brown,
                            ),
                          ),
                        ],


                                    ],
                                  
                                ),
                              ),
                            );
                          }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required Color iconColor,
    bool hasMoreInfo = false,
  }) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? DatingColors.everqpidColor : DatingColors.lightpink,
          width: 2,
        
        ),
        borderRadius: BorderRadius.circular(12),
        color: DatingColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: iconColor,
                ),
                if (hasMoreInfo)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DatingColors.everqpidColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MORE INFO',
                        style: TextStyle(
                          color: DatingColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DatingColors.everqpidColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: DatingColors.lightgrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required Color iconColor,
  }) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? DatingColors.primaryGreen : DatingColors.lightpink,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: DatingColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
              color: iconColor,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DatingColors.everqpidColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: DatingColors.lightgrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
