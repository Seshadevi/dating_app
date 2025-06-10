import 'package:dating/screens/profile_after_click/harmful_behaviour_screen.dart';
import 'package:flutter/material.dart';



class FeelingOfRejectionScreen extends StatelessWidget {
  const FeelingOfRejectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Feeling Of Rejection',
            style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topInfoCard(),
            const SizedBox(height: 24),
            const Text(
              "Make Bumble Work For You",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
             const Text(
              "Learn About Parts Of The App That Can Help",
              style: TextStyle(
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 12),
            _horizontalCardList([
              _CardData("assets/feeling5.png", "Profile Prompts"),
              _CardData("assets/feeling6.png", "Profile Verification"),
              _CardData("assets/feeling7.png", "Reporting After Being Unmatched"),
            ]),
            const SizedBox(height: 24),
            const Text(
              "Helpful Resources",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HarmfulBehaviorScreen()));
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
            )
          ],
        ),
      ),
    );
  }

  Widget _topInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.sentiment_dissatisfied, size: 40),
          title: const Text(
            "Being Ghosted Or Ignored",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("How To Handle Feeling Of Rejection While Dating"),
        ),
        const SizedBox(height: 8),
        _horizontalCardList([
          _CardData("assets/feeling1.png", "I'm Not Getting Any Matches"),
          _CardData("assets/feeling2.png", "People Don’t Message Me First"),
          _CardData("assets/feeling3.png", "Ghosting (And When It's OK)"),
          _CardData("assets/feeling4.png", "Being Unmatched"),
        ]),
      ],
    );
  }

  Widget _horizontalCardList(List<_CardData> cards) {
    return SizedBox(
      height: 140,
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
                  child: Image.asset(
                    card.imagePath,
                    fit: BoxFit.cover,
                  ),
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          )
        ],
      ),
    );
  }
}

class _CardData {
  final String imagePath;
  final String title;
  _CardData(this.imagePath, this.title);
}
