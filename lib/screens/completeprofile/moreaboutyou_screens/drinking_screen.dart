import 'dart:ui';

import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
// import 'package:dating/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinkingScreen extends ConsumerStatefulWidget {
  final List<String>? selectedDrinks;

  const DrinkingScreen({super.key, this.selectedDrinks});

  @override
  ConsumerState<DrinkingScreen> createState() => _DrinkingScreenState();
}

class _DrinkingScreenState extends ConsumerState<DrinkingScreen> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Load options from API
      await ref.read(drinkingProvider.notifier).getdrinking();

      // Get saved user data
      final user = ref.read(loginProvider).data?.first.user;

      // Convert all selected drinking options to a string list
      if (user != null && user.drinking != null && user.drinking!.isNotEmpty) {
        selectedOptions = user.drinking!
            .map((e) => e is String
                ? e
                : e is Map && e['preference'] != null
                    ? e['preference'].toString()
                    : '')
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (widget.selectedDrinks != null) {
        selectedOptions = [...widget.selectedDrinks!];
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final drinkingState = ref.watch(drinkingProvider);
    final options = drinkingState.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, selectedOptions),
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2D12E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_drink, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do You Drink',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Show options
            if (drinkingState.data == null)
              const CircularProgressIndicator()
            else if (options.isEmpty)
              const Text("No options available")
            else
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index].preference ?? '';
                    final isSelected = selectedOptions.contains(option);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedOptions.remove(option);
                            } else {
                              selectedOptions.add(option);
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFB2D12E),
                                      Color(0xFF2B2B2B)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: isSelected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : const Color(0xFFB2D12E),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
