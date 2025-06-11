import 'package:dating/screens/profile_after_click/helpfull_resource.dart';
import 'package:dating/screens/profile_after_click/irl_screen.dart';
import 'package:flutter/material.dart';

class HarmfulBehaviorScreen extends StatelessWidget {
  const HarmfulBehaviorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Harmful Behavior", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerInfo(),
            const SizedBox(height: 16),

            // Section 1: Horizontal scrolling cards
            _horizontalCardsSection([
              _CardData("assets/harmful1.png", "Preventing Online Harassment Or Abuse"),
              _CardData("assets/harmful2.png", "Romance Scams"),
              _CardData("assets/harmful3.png", "Reporting Abusive Messages"),
              _CardData("assets/harmful4.png", "What Happens When I Report"),
              _CardData("assets/harmful5.png", "Spotting & Recovering From Catfishing"),
              _CardData("assets/harmful6.png", "Microaggressions & Fetishization"),
            ]),

            const SizedBox(height: 24),
            const Text("Make Bumble Work For You", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             const Text(
              "Learn About Parts Of The App That Can Help",
              style: TextStyle(
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 12),

            _horizontalCardsSection([
              _CardData("assets/block.png", "Block & Reports"),
              _CardData("assets/unmatch.png", "Unmatch Someone"),
              _CardData("assets/unsolicited.png", "Unsolicited Lewd Photos"),
            ]),

            const SizedBox(height: 24),
            const Text("Helpful Resources", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text(
              "Organization To Help You Feel Safe And Well",
              style: TextStyle(
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 12),

            _infoCard("Love is Respect", "Disrupts And Prevents Unhealthy Relationships And Intimate Violence"),
            const SizedBox(height: 12),
            _infoCard("Transgender India", "Bringing Change And Support In Societies For The Trans Community"),
            const SizedBox(height: 12),
            _infoCard("Rainn", "Help From A Trained Sexual Assault Support Service Provider"),

            const SizedBox(height: 24),
            _seeMoreButton(context),
          ],
        ),
      ),
    );
  }

  Widget _headerInfo() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.report_gmailerrorred_outlined, size: 40),
      title: const Text(
        "Abuse Of Any Kind Or Catfishing",
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
      ),
      subtitle: const Text("What To Do If Something Is Being Inappropriate",style: TextStyle(fontSize: 8),),
    );
  }

  Widget _horizontalCardsSection(List<_CardData> cards) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(card.imagePath, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(
                  card.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          )
        ],
      ),
    );
  }

  Widget _seeMoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Example navigation (can modify as needed)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpfulResourcesScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("See More"),
          Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}

class _CardData {
  final String imagePath;
  final String title;
  const _CardData(this.imagePath, this.title);
}
