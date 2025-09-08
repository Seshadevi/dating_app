import 'dart:async';
import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/plans/plamsfullmodel.dart';
import '../../provider/plans/plansfullprovider.dart';

class SpotlightScreen extends ConsumerStatefulWidget {
  final int typeId;
  const SpotlightScreen({super.key, required this.typeId});

  @override
  ConsumerState<SpotlightScreen> createState() => _SpotlightScreenState();
}

class _SpotlightScreenState extends ConsumerState<SpotlightScreen> {
  int selectedIndex = 0;

  final PageController _pageController = PageController(viewportFraction: 0.45);

  @override
  Widget build(BuildContext context) {
    final plansData = ref.watch(plansFullProvider).data ?? [];

    final filteredPlans =
        plansData.where((plan) => plan.typeId == widget.typeId).toList();

    if (filteredPlans.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No plans available for this type.")),
      );
    }

    final planName = filteredPlans.first.planType?.planName ?? "Plan";
    final selectedPlan = filteredPlans[selectedIndex];

    return Scaffold(
      backgroundColor: DatingColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(planName),
        centerTitle: true,
        backgroundColor: DatingColors.white,
        elevation: 0,
        foregroundColor: DatingColors.brown,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Image.asset("assets/persons.png", height: 100),

          const SizedBox(height: 10),

          // ✅ Swiping text and bubble indicator
          const SwipingHeaderText(),

          const SizedBox(height: 20),

          SizedBox(
            height: 260,
            child: PageView.builder(
              controller: _pageController,
              itemCount: filteredPlans.length,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() => selectedIndex = index);
              },
              itemBuilder: (context, index) {
                final plan = filteredPlans[index];
                
                // ✅ Duration calculation with null safety
                final int durationDays = plan.durationDays ?? 0;
                final int durationMonths = durationDays > 0 
                    ? (durationDays / 30).ceil() 
                    : 1;

                // ✅ Parse price with null safety and default to 0
                final String priceString = plan.price ?? "0";
                final double displayPrice = double.tryParse(priceString) ?? 0.0;

                // ✅ Parse quantity with null safety (minimum 1 to avoid divide-by-zero)
                final int quantity = (plan.quantity != null && plan.quantity! > 0) 
                    ? plan.quantity! 
                    : 1;

                // ✅ Calculate unit price with 2 decimal places
                final double calculatePrice = displayPrice / quantity;
                final String formattedPrice = calculatePrice.toStringAsFixed(2);

                final isSelected = selectedIndex == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DatingColors.everqpidColor
                        : DatingColors.lightpinks,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? DatingColors.lightgrey : DatingColors.everqpidColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$quantity\n${plan.title ?? 'Plan'}", // ✅ Added null safety for title
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? DatingColors.brown : DatingColors.lightpink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$formattedPrice\nINR\neach", // ✅ Show price with 2 decimal places
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? DatingColors.brown : DatingColors.lightpink,
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
                          "SAVE 38%",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold,color: DatingColors.everqpidColor,),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your Payment Account Will Be Charged ${selectedPlan.price ?? "0"} INR For "
              "${selectedPlan.quantity} ${selectedPlan.title}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),

          TextButton(
            onPressed: () {
              // TODO: Show T&C
            },
            child: const Text(
              "Terms & Conditions",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DatingColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Payment action
                },
                child: Text(
                  "Get ${selectedPlan.quantity} ${selectedPlan.title} INR For "
                  "${selectedPlan.price ?? "0"}",
                  style: const TextStyle(fontSize: 16, color: DatingColors.brown),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper method to calculate duration months with null safety
  int _getDurationMonths(int? durationDays) {
    if (durationDays == null || durationDays <= 0) return 1;
    return (durationDays / 30).ceil();
  }
}

class SwipingHeaderText extends StatefulWidget {
  const SwipingHeaderText({super.key});

  @override
  State<SwipingHeaderText> createState() => _SwipingHeaderTextState();
}

class _SwipingHeaderTextState extends State<SwipingHeaderText> {
  final PageController _textPageController = PageController();
  int _currentIndex = 0;
  late Timer _textTimer;

  final List<String> messages = [
    "5 Superswipes Per Week",
    "Unlimited Likes",
    "Boost Profile Visibility",
    "Stand Out with Spotlight",
    "See Who Liked You First",
  ];

  @override
  void initState() {
    super.initState();

    _textTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_textPageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % messages.length;
        _textPageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _textTimer.cancel();
    _textPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: PageView.builder(
            controller: _textPageController,
            itemCount: messages.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  messages[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            messages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? DatingColors.everqpidColor
                    : DatingColors.lightgrey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}