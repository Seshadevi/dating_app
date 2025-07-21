import 'package:dating/provider/signupprocessProviders/kidsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HaveKidsScreen extends ConsumerStatefulWidget {
  const HaveKidsScreen({super.key});

  @override
  ConsumerState<HaveKidsScreen> createState() => _HaveKidsScreenState();
}

class _HaveKidsScreenState extends ConsumerState<HaveKidsScreen> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(kidsProvider.notifier).getKids());
  }

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.clear();
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final kidsState = ref.watch(kidsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BC34A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.child_friendly, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Do You Have Kids?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            kidsState.data == null || kidsState.data!.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: kidsState.data!.length,
                      itemBuilder: (context, index) {
                        final option = kidsState.data![index].kids?? '';
                        final isSelected = selectedOptions.contains(option);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              toggleOption(option);
                              Navigator.pop(context, option); // Go back with selected value
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xffB2D12E),
                                          Color(0xFF2B2B2B),
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
                                      : const Color(0xffB2D12E),
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

            // Skip Button
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
