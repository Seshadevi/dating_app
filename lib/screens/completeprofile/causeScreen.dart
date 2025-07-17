import 'package:dating/provider/signupprocessProviders/causesProvider.dart';
import 'package:dating/screens/completeprofile/favoriteCauses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CausesScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> usersCauses;
  const CausesScreen({Key? key, required this.usersCauses}) : super(key: key);

  @override
  ConsumerState<CausesScreen> createState() => _CausesScreenState();
}

class _CausesScreenState extends ConsumerState<CausesScreen> {
  final Set<int> selectedIds = {};
  final int maxSelection = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(causesProvider.notifier).getCauses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final causeState = ref.watch(causesProvider);
    final causes = causeState.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Causes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can choose ${maxSelection - selectedIds.length} more causes",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text("Causes & Communities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: causes.map((cause) {
                  final isSelected = selectedIds.contains(cause.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIds.remove(cause.id);
                        } else if (selectedIds.length < maxSelection) {
                          selectedIds.add(cause.id!);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromARGB(255, 218, 217, 215) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cause.causesAndCommunities ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isSelected ? Icons.close : Icons.add,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedIds.isNotEmpty
                  ? () {
                      final selectedCauses = causes
                          .where((c) => selectedIds.contains(c.id))
                          .map((c) => {
                                'id': c.id,
                                'causesAndCommunities': c.causesAndCommunities ?? '',
                              })
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteCauseScreen(
                            userCauses: widget.usersCauses,
                            selectedCauses: selectedCauses,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF869E23),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
