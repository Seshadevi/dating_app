import 'package:dating/provider/plans/plansfullprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/model/plans/plamsfullmodel.dart';

class PayPlanTab extends ConsumerStatefulWidget {
  const PayPlanTab({super.key});

  @override
  ConsumerState<PayPlanTab> createState() => _PayPlanTabState();
}

class _PayPlanTabState extends ConsumerState<PayPlanTab> {
  int selectedPlanIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(plansFullProvider.notifier).getPlans();
    });
  }

  // Helper method to build all features list with conditional checkmarks
  List<Widget> _buildAllFeaturesList(List<Data> featurePlans, int selectedPlanIndex) {
    if (featurePlans.isEmpty || selectedPlanIndex >= featurePlans.length) {
      return [];
    }
    
    // Get all unique features from all plans
    Set<String> allFeatures = {};
    for (var plan in featurePlans) {
      if (plan.planType?.features != null && plan.planType!.features!.isNotEmpty) {
        for (var feature in plan.planType!.features!) {
          if (feature.featureName != null && feature.featureName!.isNotEmpty) {
            allFeatures.add(feature.featureName!);
          }
        }
      }
    }
    
    // Get features of selected plan
    Set<String> selectedPlanFeatures = {};
    final selectedPlan = featurePlans[selectedPlanIndex];
    if (selectedPlan.planType?.features != null && selectedPlan.planType!.features!.isNotEmpty) {
      for (var feature in selectedPlan.planType!.features!) {
        if (feature.featureName != null && feature.featureName!.isNotEmpty) {
          selectedPlanFeatures.add(feature.featureName!);
        }
      }
    }

    // Debug: Print selected plan features
    print("=== FEATURE ANALYSIS ===");
    print("Selected Plan Index: $selectedPlanIndex");
    print("Selected Plan: ${selectedPlan.title}");
    print("Selected Plan Features: $selectedPlanFeatures");
    print("All Features: $allFeatures");
    
    if (allFeatures.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            "No features available for this plan",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ];
    }
    
    // Build widgets for each feature
    return allFeatures.map((featureName) {
      final hasFeature = selectedPlanFeatures.contains(featureName);
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasFeature ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasFeature ? Colors.green.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: hasFeature ? Colors.green : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                hasFeature ? Icons.check : Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                featureName,
                style: TextStyle(
                  fontSize: 14,
                  color: hasFeature ? Colors.black87 : Colors.grey.shade600,
                  fontWeight: hasFeature ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(plansFullProvider);
    final plans = model.data ?? [];

    // Separate plans with and without features
    final plansWithoutFeatures = plans.where((p) => 
        p.planType?.features?.isEmpty ?? true).toList();
    
    // Filter top 2 boxes (Spotlight & Superswipe)
    final spotlightPlan = plansWithoutFeatures.where((p) => 
        p.title?.toLowerCase().contains('spotlight') == true).firstOrNull;
    
    final superswipePlan = plansWithoutFeatures.where((p) => 
        p.title?.toLowerCase().contains('superswipe') == true).firstOrNull;
    
    // Bottom 3 boxes - Get Premium, Premium++, and Boost plans specifically
    List<Data> featurePlans = [];
    
    // Find Premium plan (exact match or contains premium but not ++)
    final premiumPlan = plans.where((p) {
      final title = p.title?.toLowerCase() ?? '';
      return (title == 'premium' || 
              (title.contains('premium') && 
               !title.contains('++') && 
               !title.contains('premium+') &&
               !title.contains('premium +')));
    }).firstOrNull;
    
    // Find Premium++ plan (any variation of premium++)
    final premiumPlusPlan = plans.where((p) {
      final title = p.title?.toLowerCase() ?? '';
      return (title.contains('premium++') || 
              title.contains('premium ++') || 
              title.contains('premium+') ||
              title.contains('premium +'));
    }).firstOrNull;
    
    // Find Boost plan
    final boostPlan = plans.where((p) => 
        p.title?.toLowerCase().contains('boost') == true).firstOrNull;
    
    // Add plans to featurePlans list in order
    if (premiumPlan != null) featurePlans.add(premiumPlan);
    if (premiumPlusPlan != null) featurePlans.add(premiumPlusPlan);
    if (boostPlan != null) featurePlans.add(boostPlan);
    
    // Debug: Print plan names and their features
    print("=== PLAN ANALYSIS ===");
    for (int i = 0; i < plans.length; i++) {
      final plan = plans[i];
      print("Plan $i: ${plan.title}");
      print("  - Has features: ${plan.planType?.features?.isNotEmpty ?? false}");
      print("  - Feature count: ${plan.planType?.features?.length ?? 0}");
      if (plan.planType?.features != null) {
        for (var feature in plan.planType!.features!) {
          print("    * ${feature.featureName}");
        }
      }
    }
    
    print("Premium Plan: ${premiumPlan?.title}");
    print("Premium++ Plan: ${premiumPlusPlan?.title}");
    print("Boost Plan: ${boostPlan?.title}");
    print("Feature Plans: ${featurePlans.map((p) => p.title).toList()}");
    print("All Plans: ${plans.map((p) => p.title).toList()}");

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: model.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP: Spotlight & Superswipe (2 boxes)
                  Row(
                    children: [
                      // Spotlight Box
                      if (spotlightPlan != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (spotlightPlan.typeId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NextPage(typeId: spotlightPlan.typeId!),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 213, 227, 156),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF869E23)),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.highlight, size: 32, color: Color(0xFF869E23)),
                                  const SizedBox(height: 8),
                                  Text(
                                    spotlightPlan.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${spotlightPlan.quantity ?? 0} Left",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      // Superswipe Box
                      if (superswipePlan != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (superswipePlan.typeId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NextPage(typeId: superswipePlan.typeId!),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 213, 227, 156),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF869E23)),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.favorite, size: 32, color: Color(0xFF869E23)),
                                  const SizedBox(height: 8),
                                  Text(
                                    superswipePlan.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${superswipePlan.quantity ?? 0} Left",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // BOTTOM: Premium, Premium++, Boost (3 horizontal boxes)
                  if (featurePlans.isNotEmpty)
                    SizedBox(
                      height: 180,
                      // width: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: featurePlans.length,
                        itemBuilder: (context, index) {
                          final plan = featurePlans[index];
                          final isSelected = selectedPlanIndex == index;
                          
                          Color planColor = Color(0xFF869E23);
                          IconData planIcon = Icons.star;
                          
                          // Dynamic color based on plan title
                          // final title = plan.title?.toLowerCase() ?? '';
                          // if (title.contains('premium++') || title.contains('premium +')) {
                          //   planColor = Colors.purple;
                          //   planIcon = Icons.star_border;
                          // } else if (title.contains('boost')) {
                          //   planColor =  Color(0xFF869E23);
                          //   planIcon = Icons.rocket_launch;
                          // } else if (title.contains('premium')) {
                          //   planColor = Color(0xFF869E23);
                          //   planIcon = Icons.star;
                          // }
                          
                          return GestureDetector(
                            onTap: () => setState(() => selectedPlanIndex = index),
                            child: Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? planColor : Color.fromARGB(255, 239, 239, 197),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected 
                                    ? Border.all(color: planColor, width: 2)
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        planIcon,
                                        size: 24,
                                        color: isSelected ? Colors.white : planColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          plan.title ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isSelected ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      plan.planType?.description ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected ? Colors.white70 : Colors.grey.shade700,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (plan.typeId != null) {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => NextPage(typeId: plan.typeId!),
                                          //   ),
                                          // );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected ? Colors.white : planColor,
                                        foregroundColor: isSelected ? planColor : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Explore More"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // FEATURES: Tab bar with all features and selective checkmarks
                  if (featurePlans.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with Tab Bar
                          const Text(
                            "What you get:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Tab Bar for Premium, Premium++, Boost
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: featurePlans.asMap().entries.map((entry) {
                                final index = entry.key;
                                final plan = entry.value;
                                final isSelected = selectedPlanIndex == index;
                                
                                Color planColor = Colors.blue;
                                final title = plan.title?.toLowerCase() ?? '';
                                if (title.contains('premium++') || title.contains('premium +')) {
                                  planColor = Colors.purple;
                                } else if (title.contains('boost')) {
                                  planColor =  Color(0xFF869E23);
                                } else if (title.contains('premium')) {
                                  planColor =  Color(0xFF869E23);
                                }
                                
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => selectedPlanIndex = index),
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: isSelected ? planColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          plan.title ?? '',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // All Features List with Conditional Checkmarks
                          SizedBox(
                            height: 300, // Fixed height for scroll
                            child: SingleChildScrollView(
                              child: Column(
                                children: _buildAllFeaturesList(featurePlans, selectedPlanIndex),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class NextPage extends StatelessWidget {
  final int typeId;
  const NextPage({super.key, required this.typeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Page"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.explore,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              "Selected Type ID: $typeId",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ProfileInsightsTab extends StatelessWidget {
  const ProfileInsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How Are Your Photos Doing?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "See Which Of Your Photos Are Getting The Most Attention.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Bar Graphs
            // SizedBox(
            //   height: 100,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: List.generate(8, (index) {
            //       double height = index == 0
            //           ? 100
            //           : index == 1
            //               ? 80
            //               : index == 2
            //                   ? 60
            //                   : 30;
            //       return Container(
            //         width: 18,
            //         height: height,
            //         decoration: BoxDecoration(
            //           color: index < 3
            //               ? const Color(0xFF6A8E00)
            //               : const Color(0xFFE6F3B3),
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       );
            //     }),
            //   ),
            // ),

            // const SizedBox(height: 12),

            // // Profile Photos Row
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     for (int i = 0; i < 4; i++)
            //       const CircleAvatar(
            //         backgroundImage: AssetImage(
            //             'assets/user.png'), // Replace with your asset
            //         radius: 18,
            //       ),
            //     for (int i = 0; i < 4; i++)
            //       const CircleAvatar(
            //         radius: 18,
            //         backgroundColor: Color(0xFFE6F3B3),
            //         child: Icon(Icons.add, color: Colors.black),
            //       ),
            //   ],
            // ),
             Image.asset(
              'assets/graph_tab.png', // replace with your image asset
              height: 200,
              width: 500,
            ),

            const SizedBox(height: 16),

            const Text(
              "your latest insights",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Add photos recommendation box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF5A5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Add More Than 3 Photos To Be 43% More Likely To Get A Match.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Tips For Great Photos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Tip cards
            _tipCard(
              imagePath: 'assets/profile_insights_tab1.png',
              text: "Avoid Mirror Selfies, And Photos\nWith Filters.",
              icon: Icons.info_outline,
              iconColor: Colors.black,
            ),
            const SizedBox(height: 12),
            _tipCard(
              imagePath: 'assets/profile_insights_tab2.png',
              text:
                  "Include A Bright And Clear Photo Of Just You. Even Better If You're Smiling!",
              icon: Icons.check,
              iconColor: Colors.black,
            ),
            const SizedBox(height: 12),
            _tipCard(
              imagePath: 'assets/profile_insights_tab5.png',
              text: "Add Photos That Show Your Lifestyle And What You're Into.",
              icon: Icons.check,
              iconColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

 Widget _tipCard({
  required String imagePath,
  required String text,
  required IconData icon,
  required Color iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFDFF5A5),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IMAGE
        SizedBox(
           width: 80,
              height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Image.asset(
              imagePath,
             
              // fit: BoxFit.co,
            ),
          ),
        ),

        const SizedBox(width: 1),

        // TEXT + ICON
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Column
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 6),

              // Icon
              Icon(icon, color: iconColor),
            ],
          ),
        ),
      ],
    ),
  );
}


}

class SafetyTab extends StatelessWidget {
  const SafetyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top horizontal cards
            SizedBox(
              height: 215,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _infoCard(
                    title: "Mental Exhaustion",
                    subtitle:
                        "Help With Dating Anxiety,\nUncertainty Or Burnout",
                    imagePath: "assets/safty_bar1.png", // Replace with actual image
                    bgColor: const Color(0xFFDFF5A5),
                  ),
                  const SizedBox(width: 6),
                  _infoCard(
                    title: "Feelings Of...",
                    subtitle: "Incomplete data",
                    imagePath: "assets/safty_bar2.png", // Replace accordingly
                    bgColor: const Color(0xFFF6F5F2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Get Help Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              child: const Text(
                "Get Help From Ever Qupid",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Help options
            _helpTile(
              icon: Icons.verified_user,
              title: "Your Safety",
              subtitle: "Trusted Organisations To Help Keep You Safe And Well",
            ),
            const SizedBox(height: 12),
            _helpTile(
              icon: Icons.favorite,
              title: "Your Emotional Wellbeing",
              subtitle:
                  "Resources For A Healthy State Of Mind In Dating And In Life.",
            ),
            const SizedBox(height: 12),
            _helpTile(
              icon: Icons.gavel,
              title: "Values And Guidelines",
              subtitle:
                  "Ever Qupid See What Ever Qupid Stands For And What We Ask Of Our Community",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color bgColor,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80), // Replace with your asset
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _helpTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF5A5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.lightGreen,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
