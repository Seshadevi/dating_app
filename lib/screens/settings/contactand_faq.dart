import 'dart:ui';

import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/settings/privacusetting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Contactandfaq extends ConsumerStatefulWidget {
  const Contactandfaq({super.key});

  @override
  ConsumerState<Contactandfaq> createState() => ContactandfaqState();
}

class ContactandfaqState extends ConsumerState<Contactandfaq> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white ,
      appBar: AppBar(
        backgroundColor: isDarkMode ? DatingColors.black : DatingColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Contact And FAQ',
          style: TextStyle(
            color: isDarkMode ? DatingColors.white : DatingColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Way You Can Log In section
            _buildMenuOption(
              title: 'FAQ',
              onTap: () {},
            ),

            const SizedBox(height: 10),

            // Privacy Settings option
            _buildMenuOption(
              title: 'Contact US',
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Privacy Settings option
            _buildMenuOption(
              title: 'Terms Of Service',
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // Privacy Settings option
            _buildMenuOption(
              title: 'Privacy Policy',
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Privacysetting()));
              },
            ),
            const SizedBox(height: 20),

            // Privacy Settings option
            _buildMenuOption(
              title: 'Advertising',
              onTap: () {},
            ),
          ],
        ),
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
