import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/tab_bar/subscriptioncontent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/plans/plansfullprovider.dart';
import '../../model/plans/plamsfullmodel.dart';
// import 'spotlight_tab_content.dart'; // Reuse Spotlight UI for each tab

class SubscriptionTabScreen extends ConsumerWidget {
  final int typeId; // passed via navigation
  const SubscriptionTabScreen({super.key, required this.typeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(plansFullProvider).data ?? [];

    // 🔍 Get the clicked plan's planName by typeId
    final Data? clickedPlan =
        plans.firstWhere((p) => p.typeId == typeId, orElse: () => Data());

    final String? clickedPlanName = clickedPlan?.planType!.planName;

    // 👇 Collect all available plan types by planName
    final Map<String, int> allTabsMap = {
      for (var p in plans)
        if (p.planType?.planName != null) p.planType!.planName!: p.typeId ?? 0
    };

    // 📌 Tabs to show based on logic
    final List<MapEntry<String, int>> tabsToShow = [];

    if (clickedPlanName == "Premium") {
      if (allTabsMap.containsKey("Premium")) {
        tabsToShow.add(MapEntry("Premium", allTabsMap["Premium"]!));
      }
      if (allTabsMap.containsKey("Premium+")) {
        tabsToShow.add(MapEntry("Premium+", allTabsMap["Premium+"]!));
      }
    } else if (clickedPlanName == "Boost") {
      if (allTabsMap.containsKey("Boost")) {
        tabsToShow.add(MapEntry("Boost", allTabsMap["Boost"]!));
      }
      if (allTabsMap.containsKey("Premium")) {
        tabsToShow.add(MapEntry("Premium", allTabsMap["Premium"]!));
      }
    } else if (clickedPlanName == "Premium+") {
      if (allTabsMap.containsKey("Premium+")) {
        tabsToShow.add(MapEntry("Premium+", allTabsMap["Premium+"]!));
      }
    } else {
      // fallback: show everything
      tabsToShow.addAll(allTabsMap.entries);
    }

    return DefaultTabController(
      length: tabsToShow.length,
      child: Scaffold(
        backgroundColor: DatingColors.white,
        appBar: AppBar(
          title: const Text('Subscription'),
          centerTitle: true,
          backgroundColor: DatingColors.white,
          elevation: 0,
          foregroundColor: DatingColors.black,
          bottom: TabBar(
            isScrollable: true,
            labelColor: DatingColors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: DatingColors.black,
            tabs: tabsToShow
                .map((entry) => Tab(text: entry.key))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: tabsToShow
              .map((entry) => SpotlightTabContent(typeId: entry.value))
              .toList(),
        ),
      ),
    );
  }
}
