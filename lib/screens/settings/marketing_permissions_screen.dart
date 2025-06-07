import 'package:dating/screens/settings/privacusetting_screen.dart';

import 'package:flutter/material.dart';

class Marketingpartners extends StatefulWidget {
  const Marketingpartners({super.key});

  @override
  State<Marketingpartners> createState() => MarketingpartnersState();
}

class MarketingpartnersState extends State<Marketingpartners> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Marketing Partners',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPartnerCard(
            title: 'Appsflyer',
            description: 'Used To Improve The Performance Of Heart Sync Own Advertising.',
          ),
          const SizedBox(height: 16),
          _buildPartnerCard(
            title: 'Google Advertising Products',
            description: 'Used To Improve The Performance Of Heart Sync Own Advertising.',
          ),
          const SizedBox(height: 16),
          _buildPartnerCard(
            title: 'Google Firebase',
            description: 'Used To Improve The Performance Of Heart Sync Own Advertising And To Provide App Usage Insights',
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard({
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>Privacysetting()
              )
              );
            },
            child: const Text(
              'View Privacy Policy',
              style: TextStyle(
                fontSize: 18,
                color: Colors.amber,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}