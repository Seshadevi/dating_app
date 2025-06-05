import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';

class MyHeartsyncPage extends StatefulWidget {
  const MyHeartsyncPage({super.key});

  @override
  State<MyHeartsyncPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHeartsyncPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'Heart Sync',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              // Profile Image Section
              Container(
                height: 450,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25),
                  child: Stack(
                    children: [
                     
                        Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(65),
                            topRight: Radius.circular(65),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              const Color.fromARGB(20, 123, 116, 155)
                              
                            ],
                          ),
                        ),
                      ),
                      // Background image with rounded top corners
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(95),
                      //       topRight: Radius.circular(95),
                      //     ),
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/app_icon.jpg'), // Replace with your image
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      
                    
                      // Profile content
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Online indicator
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Name and age
                            Text(
                              'P, 24',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButton(Icons.close, Colors.grey[300]!),
                                SizedBox(width: 15),
                                _buildActionButton(Icons.favorite, Colors.pink),
                                SizedBox(width: 15),
                                _buildActionButton(Icons.star, Colors.blue),
                              ],
                            ),
                            SizedBox(height: 20),
                            
                            // Things You Can Bond Over - Inside the image container
                            Text(
                              'Things You Can Bond Over',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                _buildBondTagWhite('🎵 Music and Karaoke'),
                                SizedBox(width: 10),
                                _buildBondTagWhite('🎭 Play'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Profile details section
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Row(
                      children: [
                        Text(
                          'Perry Kate',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    // About section
                    _buildSectionHeader('About'),
                    SizedBox(height: 10),
                    Text(
                      'Making Heart Sync the Right Fit Fun, Laughter, And Maybe Something Special... 😉 Made',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Interest section
                    _buildSectionHeader('Interest'),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildInterestChip('⚽ Football'),
                        _buildInterestChip('🌿 Nature'),
                        _buildInterestChip('🎵 Music'),
                        _buildInterestChip('📷 Photography'),
                        _buildInterestChip('✍ Writing'),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    // About Me section
                    _buildSectionHeader('About Me'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip('📏 164 Cm'),
                        SizedBox(width: 10),
                        _buildInfoChip('🕐 Sometimes'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip('♏ Scorpio'),
                        SizedBox(width: 10),
                        _buildInfoChip('🏋 Weight'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip('📏 164 Cm'),
                        SizedBox(width: 10),
                        _buildInfoChip('🍷 Drink'),
                        SizedBox(width: 10),
                        _buildInfoChip('⚖ Libra'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip('🎓 Postgraduate Degree'),
                        SizedBox(width: 10),
                        _buildInfoChip('🕉 Hindu'),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    // I Am Looking For section
                    _buildSectionHeader('I Am Looking For'),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        _buildLookingForItem('💕 Intimacy', true),
                        _buildLookingForItem('💕 Intimacy, Without Commitment', false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: icon == Icons.close ? Colors.grey[600] : Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildBondTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildBondTagWhite(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildLookingForItem(String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.pink : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}