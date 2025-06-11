
import 'package:dating/screens/completeprofile/complete_profile.dart';
import 'package:dating/screens/profile_screens/profile_insights_screen.dart';
import 'package:dating/screens/profile_screens/profile_payplan_screen.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:dating/screens/profile_screens/safety_and_wellbeingcontent.dart';
import 'package:flutter/material.dart';

class ProfileHeaderLayout extends StatefulWidget {
  const ProfileHeaderLayout({super.key});

  @override
  State<ProfileHeaderLayout> createState() => _ProfileHeaderLayoutState();
}

class _ProfileHeaderLayoutState extends State<ProfileHeaderLayout> {
  int selectedTabIndex = 0; // Track selected tab (0: Pay Plan, 1: Profile Insights, 2: Safety)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
          }
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Fixed Header Section
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Section
                Row(
                  children: [
                    // Profile Image with Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress Circle
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: 0.2, // 20% progress
                            strokeWidth: 3,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                        // Profile Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300], // Placeholder color
                            // image: DecorationImage(
                            //   image: AssetImage('assets/profile_image.jpg'),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          child: Icon(Icons.person, color: Colors.grey[600], size: 30),
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    // Name and Progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keerthana_3',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '20%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BumbleDateProfileScreen()));
                                },
                                child: Container(
                                  
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Complete Profile',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Icons
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.qr_code,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.settings,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Action Buttons with Selection
                Row(
                  children: [
                    // Pay Plan Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: selectedTabIndex == 0
                              ? LinearGradient(
                                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTabIndex = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTabIndex == 0 ? Colors.transparent : Colors.white,
                            foregroundColor: selectedTabIndex == 0 ? Colors.white : Colors.black,
                            shadowColor: Colors.transparent,
                            side: selectedTabIndex == 0 ? null : BorderSide(color: Colors.grey[300]!, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Pay Plan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    // Profile Insights Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: selectedTabIndex == 1
                              ? LinearGradient(
                                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                              
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTabIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTabIndex == 1 ? Colors.transparent : Colors.white,
                            foregroundColor: selectedTabIndex == 1 ? Colors.white : Colors.black,
                            shadowColor: Colors.transparent,
                            side: selectedTabIndex == 1 ? null : BorderSide(color: Colors.grey[300]!, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Profile Insights',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    // Safety And Wellbeing Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: selectedTabIndex == 2
                              ? LinearGradient(
                                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTabIndex = 2;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTabIndex == 2 ? Colors.transparent : Colors.white,
                            foregroundColor: selectedTabIndex == 2 ? Colors.white : Colors.black,
                            shadowColor: Colors.transparent,
                            side: selectedTabIndex == 2 ? null : BorderSide(color: Colors.grey[300]!, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Safety And Wellbeing',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Dynamic Content Area - Show different screens based on selected tab
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (selectedTabIndex) {
      case 0:
        return ProfilePayplanScreen();
      case 1:
        return ProfileInsightsScreen();
      case 2:
        return SafetyAndWellbeingcontent();
      default:
        return ProfilePayplanScreen();
    }
  }
}