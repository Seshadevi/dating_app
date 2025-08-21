import "package:dating/constants/dating_app_user.dart";
import "package:flutter/material.dart";


class ProfileStrengthDetailScreen extends StatefulWidget {
  const ProfileStrengthDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProfileStrengthDetailScreen> createState() => _ProfileStrengthDetailScreenState();
}

class _ProfileStrengthDetailScreenState extends State<ProfileStrengthDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor:DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Strength',
          style: TextStyle(
            color: DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile circle with percentage
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 0.2,
                    strokeWidth: 6,
                    backgroundColor: DatingColors.surfaceGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(DatingColors.accentTeal),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/100x100/FF8C42/FFFFFF?text=User'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: DatingColors.accentTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '20%',
                      style: TextStyle(
                        color: DatingColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Title and subtitle
            const Text(
              'Build Your Profile With Your Favorites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DatingColors.black,
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
                _buildProfileCard(
                  icon: Icons.person_outline,
                  title: 'Bio',
                  subtitle: 'Not Written',
                  isCompleted: false,
                  iconColor: DatingColors.accentTeal,
                ),
                _buildProfileCard(
                  icon: Icons.verified_user_outlined,
                  title: 'Get Verified',
                  subtitle: 'Not Verified',
                  isCompleted: false,
                  iconColor: DatingColors.accentTeal,
                ),
                _buildProfileCard(
                  icon: Icons.person,
                  title: 'Basic Info',
                  subtitle: '1 Of 5 Added',
                  isCompleted: false,
                  iconColor: DatingColors.errorRed,
                ),
                _buildProfileCard(
                  icon: Icons.info_outline,
                  title: 'More About You',
                  subtitle: '3 Of 9 Added',
                  isCompleted: false,
                  iconColor: DatingColors.yellow,
                  hasMoreInfo: true,
                ),
                _buildProfileCard(
                  icon: Icons.photo_library_outlined,
                  title: 'Photos',
                  subtitle: '1 Of 4 Added',
                  isCompleted: false,
                  iconColor: DatingColors.darkGreen,
                ),
                _buildProfileCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Prompts',
                  subtitle: '3 Of 9 Added',
                  isCompleted: false,
                  iconColor: DatingColors.accentTeal,
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Interests card (single width)
            _buildSingleProfileCard(
              icon: Icons.interests_outlined,
              title: 'Interests',
              subtitle: '0 Of 5 Added',
              isCompleted: false,
              iconColor: DatingColors.lightyellow,
            ),
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
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? DatingColors.primaryGreen : DatingColors.yellow!,
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
                  size: 40,
                  color: iconColor,
                ),
                if (hasMoreInfo)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DatingColors.yellow,
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
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DatingColors.black,
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
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? DatingColors.primaryGreen : DatingColors.yellow!,
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
              size: 40,
              color: iconColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DatingColors.black,
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
