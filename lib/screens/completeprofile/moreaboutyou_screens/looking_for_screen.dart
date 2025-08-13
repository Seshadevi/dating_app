import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/signupprocessProviders/lookingProvider.dart';
import 'package:dating/screens/completeprofile/moreaboutyou_screens/relationship_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LookingForScreen extends ConsumerStatefulWidget {
  const LookingForScreen({super.key});

  @override
  ConsumerState<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends ConsumerState<LookingForScreen> {
  List<int> selectedOptionIds = []; // store selected option IDs

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(lookingProvider.notifier).getLookingForUser();

      final userState = ref.read(loginProvider);
      final user = userState.data != null && userState.data!.isNotEmpty
          ? userState.data![0].user
          : null;

      final lookingForList = user?.lookingFor;
      if (lookingForList != null && lookingForList.isNotEmpty) {
        selectedOptionIds = lookingForList
            .map((item) => item.id as int) // assuming id is int
            .toList();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lookingState = ref.watch(lookingProvider);
    final options = lookingState.data ?? [];

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
                  child: const Icon(Icons.search, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'What Are You Looking For',
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

            /// Options List
            Expanded(
              child: lookingState.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : options.isEmpty
                      ? const Center(child: Text("No options available"))
                      : ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final optionId = option.id as int;
                            final optionValue =
                                option.value?.toString().trim() ?? '';
                            final isSelected =
                                selectedOptionIds.contains(optionId);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedOptionIds.remove(optionId);
                                    } else {
                                      if (selectedOptionIds.length < 2) {
                                        selectedOptionIds.add(optionId);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'You can select up to 2 options only')),
                                        );
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xffB2D12E),
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
                                          : const Color(0xffB2D12E),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      optionValue,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),

            /// Update Button (only when selection is not empty)
            if (selectedOptionIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB2D12E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    await ref.read(loginProvider.notifier).updateProfile(
                          lookingfor: selectedOptionIds,
                          interestId: null,
                          image: null,
                          modeid: null,
                          bio: null,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                          causeId: null,
                        );

                    // if (context.mounted) {
                    //   ref.invalidate(loginProvider); // refresh profile data
                      Navigator.pop(context);
                    // }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            /// Skip Button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RelationshipScreen()),
                  );
                },
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
