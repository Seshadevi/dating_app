import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';

class ProfileInsightsScreen extends StatefulWidget {
  const ProfileInsightsScreen({super.key});

  @override
  State<ProfileInsightsScreen> createState() => _ProfileInsightsScreenState();
}

class _ProfileInsightsScreenState extends State<ProfileInsightsScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     child:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium upgrade card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: DatingColors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: DatingColors.darkGreen,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text content
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Out How Your Photos Are',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Performing With Premium',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Section title
              const Text(
                'How Are Your Photos Doing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'See Which Of Your Photos Are Getting The Most Attention',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Performance bars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPerformanceBar(height: 200, opacity: 1.0),
                  _buildPerformanceBar(height: 200, opacity: 0.8),
                  _buildPerformanceBar(height: 200, opacity: 0.7),
                  _buildPerformanceBar(height: 200, opacity: 0.5),
                  _buildPerformanceBar(height: 200, opacity: 0.3),
                  _buildPerformanceBar(height: 200, opacity: 0.2),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Photo placeholders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildPhotoPlaceholder()),
              ),
              
              const SizedBox(height: 24),
              
              // Bottom text
              const Text(
                'Photos Insights Can Take A Little While To Appear Make Sure You Have Best Photo On',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceBar({required double height, required double opacity}) {
    return Container(
      width: 24,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB8D977).withOpacity(opacity * 0.3),
            Color(0xFFB8D977).withOpacity(opacity),
          ],
        ),
        border: Border.all(
          color: Color(0xFFB8D977).withOpacity(opacity),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFB8D977),
          width: 1,
        ),
      ),
    );
  }
}