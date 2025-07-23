import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/signupprocessProviders/religionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReligionScreen extends ConsumerStatefulWidget {
  const ReligionScreen({super.key});

  @override
  ConsumerState<ReligionScreen> createState() => _ReligionScreenState();
}

class _ReligionScreenState extends ConsumerState<ReligionScreen> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Fetch religion options
      await ref.read(religionProvider.notifier).getReligions();

      // Get user saved data
      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final religions = user?.religions;

      // Extract default religion from List<dynamic>
      if (religions != null  && religions.isNotEmpty) {
        final first = religions.first;

        if (first is String) {
          selectedOption = first;
        } else if (first is Map && first.containsKey('religion')) {
          selectedOption = first['religion']?.toString();
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final religionState = ref.watch(religionProvider);
    final options = religionState.data ?? [];

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
                  child: const Icon(Icons.star_border, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Do you identify with a religion',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Religion Options
            Expanded(
              child: religionState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No religions available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index].religion ?? '';
                            final isSelected = selectedOption == option;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOption = option;
                                  });
                                  Navigator.pop(context, option); // Return selected value
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [Color(0xffB2D12E), Color(0xFF2B2B2B)],
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

            /// Skip Button
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
