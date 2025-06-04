import 'package:dating/screens/tab_bar/tab_bar_widgets.dart';
import 'package:flutter/material.dart';

class PremiumPlusTab extends StatelessWidget {
  const PremiumPlusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionContent(
      imagePath: 'assets/contact.jpg',
      title: "Your Likes, Up Top",
      subtitle: "We'll Make Sure They See You Sooner",
      plans: [
        PlanData("1 Month", "198.10 INR/WK", "SAVE 50%"),
        PlanData("3 Month", "155.48 INR/WK", "SAVE 50%", isSelected: true),
        PlanData("6 Month", "69.77 INR/WK", ""),
      ],
      note:
          "Your Payment Account Will Be Charged 1,899.00 INR for 3 Months Heart Sync Premium.",
      buttonText: "Get 3 Months 1,899 INR",
    );
  }
}
