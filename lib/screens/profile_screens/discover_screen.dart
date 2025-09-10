import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text(
          "Discover",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.info_outline, color: DatingColors.everqpidColor),
          )
        ],
      ),
      
        
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: DatingColors.everqpidColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "See New People in 17 Hours",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Discover New Genuine Humans With People\nWho Match Your Vibes, Refreshed Every Day.",
              textAlign: TextAlign.center,
              style: TextStyle(color: DatingColors.everqpidColor, fontSize: 12),
            ),
            const SizedBox(height: 30),
            const Text(
              "Recommended For You",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Big Profile Card
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
                    height: 420,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Kalvin, 23",
                        style: TextStyle(
                          fontSize: 22,
                          color: DatingColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        " 0.8 km nearby",
                        style: TextStyle(color: DatingColors.white),
                      ),
                      Text(
                        "🟢 Active now",
                        style: TextStyle(color: DatingColors.lightgrey),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 40),

            // Buttons: Dislike, Star, Like
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _gradientCircleButton(Icons.thumb_down_alt_outlined, DatingColors.white),
                _gradientCircleButton(Icons.star_border_outlined, DatingColors.white),
                _gradientCircleButton(Icons.thumb_up_alt_outlined, DatingColors.white),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: DatingColors.everqpidColor,
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const Text(
                  "Based On Your Profile And Past Matches",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "similar interests",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 40),
            _horizontalCardList(),

            const SizedBox(height: 24),
            const Text(
              "same dating goals",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            _horizontalCardList(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  // Gradient Circle Button Widget
  Widget _gradientCircleButton(IconData icon, Color iconColor) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [DatingColors.primaryGreen, DatingColors.everqpidColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: DatingColors.everqpidColor, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }

  // Horizontal Scroll Cards
 Widget _horizontalCardList() {
  final profiles = [
    {
      "name": "Meenu, 25",
      "tag": "☕ Coffee",
      "img": "https://randomuser.me/api/portraits/women/1.jpg"
    },
    {
      "name": "Deepa, 25",
      "tag": "🎯 Friendship",
      "img": "https://randomuser.me/api/portraits/women/2.jpg"
    },
  ];

  return SizedBox(
    height: 270,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => const SizedBox(width: 18),
      itemBuilder: (context, index) {
        final user = profiles[index];
return Container(
  width: 140,
  decoration: BoxDecoration(
     gradient: LinearGradient(
          colors: [DatingColors.middlepink, DatingColors.everqpidColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: DatingColors.primaryGreen, width: 1.2),
    boxShadow: [
      BoxShadow(
        color: DatingColors.everqpidColor.withOpacity(0.1),
        blurRadius: 6,
        offset: Offset(2, 4),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(10), // ✅ Padding on all 4 sides
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            user['img']!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            // alignment: Alignment.topCenter,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color:DatingColors.primaryGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user['tag']!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user['name']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    ),
  ),
);

      },
    ),
  );
}
}
