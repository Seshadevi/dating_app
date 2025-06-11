import 'package:flutter/material.dart';

class SpotlightPage extends StatefulWidget {
  const SpotlightPage({super.key});

  @override
  State<SpotlightPage> createState() => _SpotlightPageState();
}

class _SpotlightPageState extends State<SpotlightPage> {
int selectedPackageIndex = 0; 

 // Package data
  final List<Map<String, dynamic>> packages = [
    {
      'spotlight': 30,
      'price': 29.97,
      'savings': 'Save 49%',
      'isPopular': true,
    },
    {
      'spotlight': 15,
      'price': 33.27,
      'savings': 'Save 43%',
      'isPopular': false,
    },
    {
      'spotlight': 5,
      'price': 39.80,
      'savings': 'Save 33%',
      'isPopular': false,
    },
    {
      'spotlight': 1,
      'price': 59.00,
      'savings': null,
      'isPopular': false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Spotlight',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Step Into The Spotlight',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'You Deserve Special Attention Get Seen Before Others For 30 Mins With Spotlight',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            
            // Package Options
            Expanded(
              child: Column(
                children: [
                  ...packages.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> package = entry.value;
                  // Most Popular Option
                 return Column(
                    children: [
                      _buildPackageOption(
                          index: index,
                          spotlight: package['spotlight'],
                          price: package['price'],
                          savings: package['savings'],
                          isPopular: package['isPopular'],
                          isSelected: selectedPackageIndex == index,
                          onTap: () {
                            setState(() {
                              selectedPackageIndex = index;
                            });
                          },
                        ),
                        if (index < packages.length - 1) const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                  
                  const SizedBox(height: 35),
                  const Text(
                    'One-Time Payment By Purchasing You Agree To This Transaction And Our Terms',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            
            // Purchase Button
           Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Handle purchase for selected package
                  final selectedPackage = packages[selectedPackageIndex];
                  print('Selected package: ${selectedPackage['spotlight']} Spotlight for ${selectedPackage['price']} INR');
                  // Add your purchase logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Get ${packages[selectedPackageIndex]['spotlight']} Spotlight${packages[selectedPackageIndex]['spotlight'] > 1 ? 's' : ''} For ${packages[selectedPackageIndex]['price'].toStringAsFixed(0)} INR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildPackageOption({
    required int index,
    required int spotlight,
    required double price,
    String? savings,
    bool isPopular = false,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8BC34A) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Popular Badge
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                   gradient: const LinearGradient(
                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Most\nPopular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            if (isPopular) const SizedBox(width: 12),
            
            // Package Details
            Expanded(
              child: Text(
                '$spotlight Spotlight${spotlight > 1 ? 's' : ''}  ${price.toStringAsFixed(2)} INR Each',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            
            // Savings Badge
            if (savings != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                   gradient: const LinearGradient(
                  colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  savings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}