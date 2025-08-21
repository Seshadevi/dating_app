import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/profile_after_click/feeling_of_rejection.dart';
import 'package:dating/screens/profile_after_click/helpfull_resource.dart';
import 'package:flutter/material.dart';

class MentalExhaustionScreen extends StatelessWidget {
  const MentalExhaustionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DatingColors.mediumGrey,
      appBar: AppBar(
        backgroundColor: DatingColors.white,
        elevation: 0,
        title: const Text(
          'Mental Exhaustion',
          style: TextStyle(color: DatingColors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DatingColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleCard(),
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
              _CardData("assets/mental4.png", "Snooze Mode"),
              _CardData("assets/mental5.png", "BFF & Bizz"),
              _CardData("assets/mental6.png", "Question Game"),
            ]),
            const SizedBox(height: 24),
            const Text(
              "Helpful Resources",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                "Bringing Change And Support In Societies Far The Trans Community"),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpfulResourcesScreen()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: DatingColors.black,
                backgroundColor: DatingColors.lightgrey,
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

  Widget _titleCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.psychology_outlined, size: 40),
          title: const Text(
            "Anxiety Uncertainty Burnout",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: const Text(
              "Support From Bumble On During And Mental Health",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8)),
        ),
        const SizedBox(height: 8),
        _horizontalCardList([
          _CardData("assets/mental1.png", "I'm Unsure Where To Start"),
          _CardData("assets/mental2.png", "I've Got Dating Burnout"),
          _CardData("assets/mental3.png", "I'm Anxious About Messaging First"),
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
              color: DatingColors.white,
              border: Border.all(color: DatingColors.primaryGreen),
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
        border: Border.all(color: DatingColors.black),
        borderRadius: BorderRadius.circular(12),
        color: DatingColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: DatingColors.black),
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
