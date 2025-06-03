import 'package:dating/screens/tab_bar/tab_bar_widgets.dart';
import 'package:flutter/material.dart';

class SpotlightTab extends StatelessWidget {
  const SpotlightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionContent(
      imagePath: 'assets/contact.jpg',
      title: "Put Yourself In The Spotlight",
      subtitle: "We'll Highlight Your Profile For 30 Minutes A Week...",
      plans: [
        PlanData("3 Month", "124.37 INR/WK", "SAVE 50%"),
        PlanData("1 Month", "279.48 INR/WK", "BEST VALUE", isSelected: true),
      ],
      note: "Your Payment Account Will Be Charged 1,099.00 INR for 1 Month Spotlight Boost.",
      buttonText: "Upgrade Now",
    );
  }
}
