import 'dart:async';
import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/plans/plansfullprovider.dart';
import '../../model/plans/plamsfullmodel.dart';

class SpotlightTabContent extends ConsumerStatefulWidget {
  final int typeId;
  const SpotlightTabContent({super.key, required this.typeId});

  @override
  ConsumerState<SpotlightTabContent> createState() =>
      _SpotlightTabContentState();
}

class _SpotlightTabContentState extends ConsumerState<SpotlightTabContent> {
  int selectedIndex = 0;
  int currentBubbleIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.45);
  Timer? _bubbleTimer;
  final List<String> swipeTexts = [
    "5 SuperSwipes Per Week",
    "Profile Boosting Weekly",
    "See Who Liked You",
    "Priority Matching",
    "Unlimited Likes"
  ];

  @override
  void initState() {
    super.initState();
    _bubbleTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentBubbleIndex = (currentBubbleIndex + 1) % swipeTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(plansFullProvider).data ?? [];
    final filteredPlans =
        plans.where((plan) => plan.typeId == widget.typeId).toList();

    if (filteredPlans.isEmpty) {
      return const Center(child: Text("No plans available for this type."));
    }

    final selectedPlan = filteredPlans[selectedIndex];
    final planName = selectedPlan.planType?.planName ?? "Plan";

    return Column(
      children: [
        const SizedBox(height: 12),
        Image.asset("assets/persons.png", height: 100), // your top image

        // const SizedBox(height: 10),

        // 🔁 Auto-changing text
        Text(
          swipeTexts[currentBubbleIndex],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // 🟢 Bubble animation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            swipeTexts.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: currentBubbleIndex == index
                    ? DatingColors.primaryGreen
                    : DatingColors.lightgrey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 🔄 Scrollable card list
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: filteredPlans.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final plan = filteredPlans[index];
              final durationDays = plan.durationDays ?? 0;
              final durationMonths =
                  durationDays > 29 ? (durationDays / 30).ceil() : durationDays;
              final price = double.tryParse(plan.price ?? "0") ?? 0;
              // final quantity = plan.quantity ?? 1;
              // final unitPrice = quantity > 0 ? price / quantity : 0;
              final isSelected = selectedIndex == index;
              final perWeek = durationDays / 7;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? DatingColors.darkGreen
                      : DatingColors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$durationMonths\nMonth",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? DatingColors.white : DatingColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "${price.toStringAsFixed(0)} INR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? DatingColors.white : DatingColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "per week ${(price/perWeek).toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? DatingColors.white :DatingColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: DatingColors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "SAVE 58%",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 💳 Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Your account will be charged ${selectedPlan.price ?? "0"} INR for "
            "${(selectedPlan.durationDays ?? 0) ~/ 30} months ${planName}.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ),

        TextButton(
          onPressed: () {},
          child: const Text(
            "Terms & Conditions",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),

        const Spacer(),

        // CTA Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: DatingColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle purchase or next
              },
              child: Text(
                "Get ${(selectedPlan.durationDays ?? 0) ~/ 30} ${planName} for ${selectedPlan.price ?? "0"}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
