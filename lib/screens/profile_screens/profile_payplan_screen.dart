
import 'package:dating/screens/profile_after_click/premium.dart';
import 'package:dating/screens/profile_screens/spotlight_page.dart';
import 'package:dating/screens/profile_screens/superswipe_page.dart';
import 'package:flutter/material.dart';

class ProfilePayplanScreen extends StatefulWidget {
  const ProfilePayplanScreen({super.key});

  @override
  State<ProfilePayplanScreen> createState() => _ProfilePayplanScreenState();
}

class _ProfilePayplanScreenState extends State<ProfilePayplanScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with Spotlight and Superswipe
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    title: 'Spotlight',
                    subtitle: 'Stand Out',
                    icon: Icons.star,
                    color: const Color(0xFF8BC34A),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SpotlightPage()));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    title: 'Superswipe',
                    subtitle: 'Get Noticed',
                    icon: Icons.favorite,
                    color: const Color(0xFF8BC34A),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SuperswipePage()));
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Premium Plans
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildPremiumCard(
                  title: 'Premium',
                  subtitle: 'Get The Vip Treatment And Enjoy Better Ways To Connect With Incredible People',
                  buttonText: 'Explore Premium',
                ),
                const SizedBox(height: 12),
                _buildPremiumCard(
                  title: 'Premium',
                  subtitle: 'Find Exactly Who You\'re Looking For, Even Faster',
                  buttonText: 'Explore Premium',
                ),
                const SizedBox(height: 12),
                _buildBoostCard(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Feature Comparison Table
          _buildFeatureComparisonTable(),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
                      colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget _buildPremiumCard({
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE4E1)),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
          child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpgradePremiumPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )

          ),
        ],
      ),
    );
  }

  Widget _buildBoostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE4E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boost',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'More Chances To Match With Extra Features To Boost Your Profile',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton(
                 onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpgradePremiumPage()));
                 },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Explore Premium',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureComparisonTable() {
    final features = [
      FeatureItem('Get Exclusive Photo Insights', premiumPlus: true),
      FeatureItem('Fast Track Your Matches', premiumPlus: true),
      FeatureItem('Stand Out Every Day', premiumPlus: true),
      FeatureItem('Unlimited Likes', premiumPlus: true, premium: true),
      FeatureItem('See Who Liked You', premiumPlus: true, premium: true),
      FeatureItem('Advanced Filters', premiumPlus: true, premium: true),
      FeatureItem('Incognito Mode', premiumPlus: true, premium: true),
      FeatureItem('Travel Mode', premiumPlus: true, premium: true),
      FeatureItem('2 Compliments a Week', premiumPlus: true),
      FeatureItem('10 Superswipes a Week', premiumPlus: true),
      FeatureItem('2 Spotlights a Week', premiumPlus: true),
      FeatureItem('Unlimited Extends', premiumPlus: true, premium: true),
      FeatureItem('Unlimited Rematch', premiumPlus: true, premium: true),
      FeatureItem('Unlimited Bcktracks', premiumPlus: true, premium: true),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'What you get:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Premium+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Premium',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Feature rows
          ...features.map((feature) => _buildFeatureRow(feature)).toList(),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(FeatureItem feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: feature.premiumPlus
                  ? const Icon(
                      Icons.check,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    )
                  : const SizedBox(),
            ),
          ),
          Expanded(
            child: Center(
              child: feature.premium
                  ? const Icon(
                      Icons.check,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final String title;
  final bool premiumPlus;
  final bool premium;

  FeatureItem(this.title, {this.premiumPlus = false, this.premium = false});
}