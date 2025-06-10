import 'package:dating/screens/profile_after_click/mentalEhausement_screen.dart';
import 'package:flutter/material.dart';

class UpgradePremiumPage extends StatelessWidget {
  const UpgradePremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: const Text('Upgrade to Premium',
            style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Likes Up Top',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Liked someone amazing? We’ll make sure they see you sooner',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 24),
            // Pricing cards
            for (final plan in [
              _Plan('1 Month', '151.43 INR / Wk', 'Most Popular',
                  isHighlighted: true),
              _Plan('3 Months', '124.37 INR / Wk', 'Best Value'),
              _Plan('1 Week', '207 INR', ''),
            ]) ...[
              plan.build(),
              const SizedBox(height: 12),
            ],
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate or purchase logic
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MentalExhaustionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A8E23),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Get 2 Superswipe For 59 INR',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Plan {
  final String title, price, tag;
  final bool isHighlighted;
  _Plan(this.title, this.price, this.tag, {this.isHighlighted = false});

  Widget build() {
    final borderColor =
        isHighlighted ? const Color(0xFFCADF7F) : Colors.grey.shade300;
    final bgColor = isHighlighted ? const Color(0xFFF9FFE7) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(price,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
            ]),
          ),
          if (tag.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFFE5F5AB)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(tag,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
