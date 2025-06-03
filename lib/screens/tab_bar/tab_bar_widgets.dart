import 'package:flutter/material.dart';

class PlanData {
  final String duration;
  final String price;
  final String badge;
  final bool isSelected;

  PlanData(this.duration, this.price, this.badge, {this.isSelected = false});
}

class SubscriptionContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final List<PlanData> plans;
  final String note;
  final String buttonText;

  const SubscriptionContent({
    required this.imagePath,
    required this.title,
    required this.plans,
    required this.note,
    required this.buttonText,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // CircleAvatar(
        //   radius: 30,
        //   backgroundColor:Color(0xFF869E23),
          // child: 
          // CircleAvatar(
  // radius: 60,
  // backgroundColor: Colors.green,
  // child: 
  Image.asset(
    imagePath,
    width: 190,
    height: 130,
    fit: BoxFit.contain,
  ),
// ),
        // ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(subtitle!, textAlign: TextAlign.center),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: plans.map((plan) => PlanCard(plan)).toList(),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        const SizedBox(height: 4),
        const Text("Terms & Conditions", style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF869E23),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Center(child: Text(buttonText, style: const TextStyle(color: Colors.white))),
          ),
        ),
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  final PlanData plan;

  const PlanCard(this.plan, {super.key});

  @override
  Widget build(BuildContext context) {
    final selected = plan.isSelected;
    return Container(
      width: 90,
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Color(0xFF869E23) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? Colors.black : Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Text(plan.duration, style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(plan.price, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 10)),
          const SizedBox(height: 4),
          if (plan.badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                plan.badge,
                style: TextStyle(fontSize: 8, color: selected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
