import 'package:dating/screens/profile_after_click/helpfull_resource.dart';
import 'package:flutter/material.dart';

class BumbleToIrlScreen extends StatelessWidget {
  const BumbleToIrlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text("Bumble To IRL", style: TextStyle(color: Colors.black)),
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
            _horizontalCardsSection([
              _CardData("assets/irl1.png", "Preparing For Safety"),
              _CardData("assets/irl2.png", "How To Navigate First Dates"),
            ]),
            const SizedBox(height: 24),
            const Text("Make Bumble Work For You",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Learn About Parts Of The App That Can Help",
                style: TextStyle(fontSize: 10,)),
            const SizedBox(height: 12),
            _horizontalCardsSection([
              _CardData("assets/irl3.png", "Video Chat"),
            ]),
            const SizedBox(height: 24),
            const Text("Helpful Resources",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text(
              "Organization To Help You Feel Safe And Well",
              style: TextStyle(
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 12),
            _infoCard("Love is Respect",
                "Disrupts And Prevents Unhealthy Relationships And Intimate Violence"),
            const SizedBox(height: 12),
            _infoCard("Transgender India",
                "Bringing Change And Support In Societies For The Trans Community"),
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
      leading: const Icon(Icons.shield_outlined, size: 40),
      title: const Text(
        "Physical Safety Dates Sex",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("How To Keep Safe When Meeting Up With Matches",style: TextStyle(fontSize: 8),),
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
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _seeMoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
         Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>HelpfulResourcesScreen()));
        // You can change this action as needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("See more tapped")),
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
