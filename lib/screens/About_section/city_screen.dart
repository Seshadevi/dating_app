import 'package:flutter/material.dart';

class FindCityScreen extends StatelessWidget {
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
    "Kolkata, Up, India",
    "Noida, Up, India",
    "North Twenty Four Parganas Wb, India",
    "Thane, Mh, India",
    "Kochi, Kl, India",
    "Ranga Reddy, Tg, India",
    "Lucknow, Mp, India",
    "Indore, Mp, India",
    "Ghaziabad, Up, India",
    "Nashik, Mh, India",
    "Surat, Gj, India",
    "Meerut, Up, India",
    "Mohali, Pb, India",
    "Nagpur, Mh, India",
    "Dehradun, Ut, India",
    "Greater Noida, Up, India",
    "Vadodara, Gj, India",
    "Bhopal, Mp, India",
    "Patna, Br, India",
    "Faridabad, Hr, India",
    "Thiruvananthapuram, Kl, India",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Your Current City',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: cities.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              // You can store the selected city or navigate to another screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${cities[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}
