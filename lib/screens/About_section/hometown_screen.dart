import 'package:flutter/material.dart';

class HomeTownSelectionScreen extends StatelessWidget {
  final List<String> cities = [
    "New Delhi, Dl, India",
    "Bengaluru Urban, Ka, India",
    "Mumbai, Mh, India",
    "Gurugram, Hr, India",
    "Pune, Mh, India",
    "Ahmedabad, Gj, India",
    "Hyderabad, Tg, India",
    "Chennai, Tn, India",
    "Jaipur, Rj, India",
    "Kolkata, Wb, India",
    "Noida, Up, India",
    "North Twenty Four Parganas Wb ,India",
    "Thane, Mh, India",
    "Kochi, Kl, India",
    "Ranga Reddy, Tg, India",
    "Lucknow, Mp, India",
    "Indore, Mp, India",
    "Ghaziabad, Up, India",
    "Haweli, Mh, India",
    "Surat, Gj, India",
    "Medchal, Tg,India",
    "Mohali, Pb, India",
    "Nagpur, Mh, India",
    "Dehradun, Ut, India",
    "Greater Noida, Up, India",
    "Vadododara, Gj, India",
    "Bhopal, Mp, India",
    "Patna, Br, India",
    "Faridabad, Hr, India",
    "Thiruvananthapuram, Kl, India",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Find Your Home Town",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Divider(),
            // List of cities
            Expanded(
              child: ListView.separated(
                itemCount: cities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Text(
                      cities[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
