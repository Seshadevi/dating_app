import 'package:dating/provider/signupprocessProviders/drinkingProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinkingScreen extends ConsumerStatefulWidget {
  const DrinkingScreen({super.key});

  @override
  ConsumerState<DrinkingScreen> createState() => _DrinkingScreenState();
}

class _DrinkingScreenState extends ConsumerState<DrinkingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(drinkingProvider.notifier).getdrinking();
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
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(height: 150),
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
                    child: const Icon(
                      Icons.local_drink,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Do You Drink',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              /// Show options from API
              if (drinkingState.data == null)
                const Center(child: CircularProgressIndicator())
              else if (options.isEmpty)
                const Center(child: Text("No options available"))
              else
                ...options.map((item) {
                  final option = item.preference ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, option); // Return selected option
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB2D12E), Color(0xFF2B2B2B)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

              const SizedBox(height: 100), // replaces Spacer()

              /// Skip button
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
