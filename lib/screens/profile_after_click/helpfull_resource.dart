import 'package:flutter/material.dart';

class HelpfulResourcesScreen extends StatefulWidget {
  const HelpfulResourcesScreen({super.key});

  @override
  State<HelpfulResourcesScreen> createState() => _HelpfulResourcesScreenState();
}

class _HelpfulResourcesScreenState extends State<HelpfulResourcesScreen> {
  bool isYourSafetySelected = true;

  // Data for each section
  final List<_Resource> safetyResources = [
    _Resource("Love is Respect", "Disrupts And Prevents Unhealthy Relationships And Intimate Violence"),
    _Resource("Transgender India", "Bringing Change And Support In Societies For The Trans Community"),
    _Resource("Rainn", "Help From A Trained Sexual Assault Support Service Provider"),
    _Resource("SNEHA", "A Non-Profit Working To Reduce Gender Violence Support Service Provider"),
    _Resource("SNEHA", "A Social Justice Movement To Fight Human Trafficking"),
  ];

  final List<_Resource> emotionalResources = [
    _Resource("Love is Respect", "Disrupts And Prevents Unhealthy Relationships And Intimate Violence"),
    _Resource("Transgender India", "Bringing Change And Support In Societies For The Trans Community"),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedResources = isYourSafetySelected ? safetyResources : emotionalResources;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Helpful Resources", style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("assets/helpful_resource.png", height: 150),
            const SizedBox(height: 16),
            _toggleButtons(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: selectedResources.length,
                itemBuilder: (context, index) {
                  final res = selectedResources[index];
                  return _infoCard(res.title, res.description);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("Your Safety", isYourSafetySelected, () {
          setState(() {
            isYourSafetySelected = true;
          });
        }),
        const SizedBox(width: 12),
        _tabButton("Emotional Wellbeing", !isYourSafetySelected, () {
          setState(() {
            isYourSafetySelected = false;
          });
        }),
      ],
    );
  }

  Widget _tabButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.green[700] : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
}

class _Resource {
  final String title;
  final String description;
  const _Resource(this.title, this.description);
}
