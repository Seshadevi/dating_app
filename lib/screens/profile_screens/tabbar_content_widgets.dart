import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/plans/plansfullprovider.dart';
import 'package:dating/screens/tab_bar/spotlight.dart';
import 'package:dating/screens/tab_bar/superswipes.dart';
import 'package:dating/screens/tab_bar/tabScreen.dart';
import 'package:dating/screens/tab_bar/tabbartotal.dart';
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
  
  // Filter properties
  bool showOnlyAvailableFeatures = false;
  String searchQuery = '';
  List<String> priorityFeatures = [
    'Unlimited Likes',
    'See Who Liked You',
    'Advanced Filters',
    'Unlimited Extends',
    'Incognito Mode'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(plansFullProvider.notifier).getPlans();
    });
  }
// Enhanced method to build filtered features list - showing only available features
List<Widget> _buildFilteredFeaturesList(List<Data> featurePlans, int selectedPlanIndex) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  if (featurePlans.isEmpty || selectedPlanIndex >= featurePlans.length) {
    return [];
  }
  
  // Get features of selected plan only
  Set<String> selectedPlanFeatures = {};
  final selectedPlan = featurePlans[selectedPlanIndex];
  if (selectedPlan.planType?.features != null && selectedPlan.planType!.features!.isNotEmpty) {
    for (var feature in selectedPlan.planType!.features!) {
      if (feature.featureName != null && feature.featureName!.isNotEmpty) {
        selectedPlanFeatures.add(feature.featureName!);
      }
    }
  }

  // Start with only features from selected plan
  List<String> filteredFeatures = selectedPlanFeatures.toList();
  
  // Apply search filter
  if (searchQuery.isNotEmpty) {
    filteredFeatures = filteredFeatures.where((feature) => 
      feature.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
  
  // Sort by priority (priority features first)
  filteredFeatures.sort((a, b) {
    final aPriority = priorityFeatures.contains(a);
    final bPriority = priorityFeatures.contains(b);
    
    if (aPriority && !bPriority) return -1;
    if (!aPriority && bPriority) return 1;
    return a.compareTo(b);
  });
  
  if (filteredFeatures.isEmpty) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          searchQuery.isNotEmpty 
            ? "No features found matching '$searchQuery'"
            : "No features available for this plan",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    ];
  }
  
  // Build widgets for each filtered feature - showing only available features
  return filteredFeatures.map((featureName) {
    final isPriority = priorityFeatures.contains(featureName);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? DatingColors.middlegrey : DatingColors.surfaceGrey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Feature name with info icon
          Expanded(
            child: Row(
              children: [
                Text(
                  featureName,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode ? DatingColors.white : DatingColors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                // Info icon (circular with 'i')
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DatingColors.everqpidColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? DatingColors.white : DatingColors.brown,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Check mark (always shown since we only display available features)
          Icon(
            Icons.check,
            color: DatingColors.accentTeal,
            size: 20,
          ),
        ],
      ),
    );
  }).toList();
}

// Simplified filter controls - only search bar
// Widget _buildFilterControls() {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     margin: const EdgeInsets.only(bottom: 16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.1),
//           blurRadius: 8,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: TextField(
//       onChanged: (value) => setState(() => searchQuery = value),
//       decoration: InputDecoration(
//         hintText: 'Search features...',
//         prefixIcon: const Icon(Icons.search),
//         suffixIcon: searchQuery.isNotEmpty
//             ? IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () => setState(() => searchQuery = ''),
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF869E23)),
//         ),
//       ),
//     ),
//   );
// }

  // Widget for filter controls
  // Widget _buildFilterControls() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     margin: const EdgeInsets.only(bottom: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Search bar
  //         TextField(
  //           onChanged: (value) => setState(() => searchQuery = value),
  //           decoration: InputDecoration(
  //             hintText: 'Search features...',
  //             prefixIcon: const Icon(Icons.search),
  //             suffixIcon: searchQuery.isNotEmpty
  //                 ? IconButton(
  //                     icon: const Icon(Icons.clear),
  //                     onPressed: () => setState(() => searchQuery = ''),
  //                   )
  //                 : null,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8),
  //               borderSide: BorderSide(color: Colors.grey.shade300),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8),
  //               borderSide: const BorderSide(color: Color(0xFF869E23)),
  //             ),
  //           ),
  //         ),
          
  //         const SizedBox(height: 12),
          
  //         // Filter toggle
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               'Show only available features',
  //               style: TextStyle(fontSize: 14),
  //             ),
  //             Switch(
  //               value: showOnlyAvailableFeatures,
  //               onChanged: (value) => setState(() => showOnlyAvailableFeatures = value),
  //               activeColor: const Color(0xFF869E23),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Features section 
  Widget _buildFeaturesSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final model = ref.watch(plansFullProvider);
    final plans = model.data ?? [];
    
    // Get feature plans (Premium, Premium++, Boost)
    List<Data> featurePlans = [];
    
    final premiumPlan = plans.where((p) {
      final title = p.title?.toLowerCase() ?? '';
      return (title == 'premium' || 
              (title.contains('premium') && 
               !title.contains('++') && 
               !title.contains('premium+') &&
               !title.contains('premium +')));
    }).firstOrNull;
    
    final premiumPlusPlan = plans.where((p) {
      final title = p.title?.toLowerCase() ?? '';
      return (title.contains('premium++') || 
              title.contains('premium ++') || 
              title.contains('premium+') ||
              title.contains('premium +'));
    }).firstOrNull;
    
    final boostPlan = plans.where((p) => 
        p.title?.toLowerCase().contains('boost') == true).firstOrNull;
    
    if (premiumPlan != null) featurePlans.add(premiumPlan);
    if (premiumPlusPlan != null) featurePlans.add(premiumPlusPlan);
    if (boostPlan != null) featurePlans.add(boostPlan);

    if (featurePlans.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? DatingColors.darkGrey : DatingColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: DatingColors. lightgrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "what you get:" and selected plan name
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? DatingColors.middlegrey : DatingColors.surfaceGrey,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "what you get:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                   color: isDarkMode ? DatingColors.white : DatingColors.brown,

                  ),
                ),
                Text(
                  featurePlans[selectedPlanIndex].title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: DatingColors.everqpidColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar for Premium, Premium++, Boost
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDarkMode ? DatingColors.middlegrey : DatingColors.surfaceGrey,
              border: Border(
                bottom: BorderSide(
                  color: DatingColors.lightBlue,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: featurePlans.asMap().entries.map((entry) {
                final index = entry.key;
                final plan = entry.value;
                final isSelected = selectedPlanIndex == index;
                
                Color planColor = DatingColors.everqpidColor;
                final title = plan.title?.toLowerCase() ?? '';
                if (title.contains('premium++') || title.contains('premium +')) {
                  planColor = DatingColors.accentTeal;
                } else if (title.contains('boost')) {
                  planColor = DatingColors.lightBlue;
                }
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPlanIndex = index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected ? Border(
                          bottom: BorderSide(
                            color: planColor,
                            width: 3,
                          ),
                        ) : null,
                      ),
                      child: Center(
                        child: Text(
                          plan.title ?? '',
                          style: TextStyle(
                            color: isSelected ? DatingColors.lightgrey : DatingColors.lightgrey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Features List
          SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: _buildFilteredFeaturesList(featurePlans, selectedPlanIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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

    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                    builder: (context) => SpotlightScreen(typeId: spotlightPlan.typeId!),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: DatingColors.everqpidColor),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.highlight, size: 32, color: DatingColors.everqpidColor),
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
                                      color: DatingColors.mediumGrey,
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
                                    builder: (context) => SuperSwipesScreen(typeId: superswipePlan.typeId!),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: DatingColors.everqpidColor),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.favorite, size: 32, color: DatingColors.everqpidColor),
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
                                      color: DatingColors.mediumGrey,
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: featurePlans.length,
                        itemBuilder: (context, index) {
                          final plan = featurePlans[index];
                          final isSelected = selectedPlanIndex == index;
                          
                          Color planColor = DatingColors.everqpidColor;
                          IconData planIcon = Icons.star;
                          
                          return GestureDetector(
                            onTap: () => setState(() => selectedPlanIndex = index),
                            child: Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected 
                                      ? planColor 
                                      : isDarkMode ? DatingColors.darkGrey : DatingColors.lightpinks,
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
                                        color: isSelected ? DatingColors.white : DatingColors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          plan.title ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isSelected ? DatingColors.brown : DatingColors.lightgrey,
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
                                        color: isSelected ? DatingColors.brown : DatingColors.lightgrey,
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SubscriptionTabScreen(typeId: plan.typeId!),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected 
                                                ? (isDarkMode ? DatingColors.darkGrey : DatingColors.white)
                                                : planColor,
                                            foregroundColor: isSelected 
                                                ? planColor 
                                                : (isDarkMode ? DatingColors.darkGrey : DatingColors.white),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child:  Text("Explore More",style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? DatingColors.white : DatingColors.lightgrey,
                                      ),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 10),
                  
                  // Filter controls
                  // if (featurePlans.isNotEmpty) _buildFilterControls(),
                  
                  // FEATURES: Tab bar with filtered features
                  if (featurePlans.isNotEmpty) _buildFeaturesSection(),
                ],
              ),
            ),
    );
  }
}