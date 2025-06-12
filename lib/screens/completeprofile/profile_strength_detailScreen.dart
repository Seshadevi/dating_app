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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Strength',
          style: TextStyle(
            color: Colors.black,
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
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
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
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '20%',
                      style: TextStyle(
                        color: Colors.white,
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
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'It\'s Quick To Set Up And Will Boost Your Chances Of Matching',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
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
                  iconColor: Colors.blue,
                ),
                _buildProfileCard(
                  icon: Icons.verified_user_outlined,
                  title: 'Get Verified',
                  subtitle: 'Not Verified',
                  isCompleted: false,
                  iconColor: Colors.blue,
                ),
                _buildProfileCard(
                  icon: Icons.person,
                  title: 'Basic Info',
                  subtitle: '1 Of 5 Added',
                  isCompleted: false,
                  iconColor: Colors.red,
                ),
                _buildProfileCard(
                  icon: Icons.info_outline,
                  title: 'More About You',
                  subtitle: '3 Of 9 Added',
                  isCompleted: false,
                  iconColor: Colors.orange,
                  hasMoreInfo: true,
                ),
                _buildProfileCard(
                  icon: Icons.photo_library_outlined,
                  title: 'Photos',
                  subtitle: '1 Of 4 Added',
                  isCompleted: false,
                  iconColor: Colors.green,
                ),
                _buildProfileCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Prompts',
                  subtitle: '3 Of 9 Added',
                  isCompleted: false,
                  iconColor: Colors.blue,
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
              iconColor: Colors.teal,
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
          color: isCompleted ? Colors.green : Colors.yellow[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MORE INFO',
                        style: TextStyle(
                          color: Colors.white,
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
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
          color: isCompleted ? Colors.green : Colors.yellow[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
