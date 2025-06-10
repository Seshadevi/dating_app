import 'package:dating/screens/settings/marketing_permissions_screen.dart';
import 'package:flutter/material.dart';

class Privacysetting extends StatefulWidget {
  const Privacysetting({super.key});

  @override
  State<Privacysetting> createState() => _PrivacysettingState();
}

class _PrivacysettingState extends State<Privacysetting> {
  bool marketingPermission = true;
  bool strictlyNecessaryPermission = true;
  bool isAccepted = false;
  bool isRejected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Setting',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main description
                  const Text(
                    'We And Our Partners Collect Information From Your Device Using Trackers, And From Your Profile And App Usage, For The Following Reasons. You Can Update These Settings At A Any Time And Learn More In Our',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle cookie policy tap
                      print('Cookie Policy tapped');
                    },
                    child: const Text(
                      'Cookie Policy',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Marketing Permission Section with Toggle
                  _buildPermissionCardWithToggle(
                    title: 'Marketing Permission',
                    value: marketingPermission,
                    onChanged: (bool newValue) {
                      setState(() {
                        marketingPermission = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Personalise Marketing Permission Section
                  _buildMenuOption(
                    title: 'Personalise Marketing Permission',
                    onTap: () {
                       Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Marketingpartners()));
                      print('Personalise Marketing Permission tapped');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description text
                  Text(
                    'These Trackers Let Us And Our Marketing Partners Improve Marketing Campaigns On Other Apps And Websites.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Strictly Necessary Permission Section with Toggle
                  _buildPermissionCardWithToggle(
                    title: 'Strictly Necessary Permission',
                    value: strictlyNecessaryPermission,
                    onChanged: null, // Disabled - can't be changed
                  ),
                  const SizedBox(height: 16),

                  _buildMenuOption(
                    title: 'View Strictly Necessary Permissions',
                    onTap: () {
                      print('View Strictly Necessary Permissions tapped');
                    },
                  ),

                  const SizedBox(height: 16),

                  // Bottom description
                  Text(
                    'These Trackers Are Needed For The App To Function So They Can\'t Be Switched Off. They Provide Essential Services Like Letting You Log In With Facebook.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100), // Extra space for buttons
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAccepted = true;
                        isRejected = false;
                      });
                      print('Accept pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAccepted
                          ? const Color(0xFF2E7D32) // Darker green when pressed
                          : const Color(0xFF4CAF50), // Normal green
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'I Accept',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isRejected = true;
                        isAccepted = false;
                      });
                      print('Reject All pressed');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isRejected ? Colors.white : Colors.black87,
                      backgroundColor:
                          isRejected ? Colors.red[600] : Colors.white,
                      side: BorderSide(
                          color: isRejected
                              ? Colors.red[600]!
                              : Colors.grey[400]!),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCardWithToggle({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: const Color.fromARGB(255, 163, 181, 6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFF4CAF50).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 163, 181, 6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF666666),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
