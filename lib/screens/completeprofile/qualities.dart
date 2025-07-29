import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/signupprocessProviders/qualities.dart';
import 'package:dating/model/signupprocessmodels/qualitiesModel.dart';
import 'package:dating/screens/completeprofile/favoritequalities.dart';

class QualitiesScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> usersQualities;

  const QualitiesScreen({Key? key, required this.usersQualities}) : super(key: key);

  @override
  ConsumerState<QualitiesScreen> createState() => _QualitiesScreenState();
}

class _QualitiesScreenState extends ConsumerState<QualitiesScreen> {
  final Set<int> selectedIds = {};
  final int maxSelection = 4;

  @override
  void initState() {
    super.initState();
    // Fetch the qualities list
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(qualitiesProvider.notifier).getQualities();

      // After qualities are fetched, pre-select the ones matching user's existing selections
      final userIds = widget.usersQualities.map((e) => e['id']).whereType<int>();
      setState(() {
        selectedIds.addAll(userIds);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualitiesState = ref.watch(qualitiesProvider);
    final qualities = qualitiesState.data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Qualities'),
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
              "You can choose ${maxSelection - selectedIds.length} more interests",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              "Self-care",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: qualities.map((quality) {
                    final isSelected = selectedIds.contains(quality.id);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIds.remove(quality.id);
                          } else if (selectedIds.length < maxSelection) {
                            selectedIds.add(quality.id!);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 218, 217, 215)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              quality.name ?? '',
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.black87,
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedIds.isNotEmpty
                  ? () {
                      final selectedQualities = qualities
                          .where((q) => selectedIds.contains(q.id))
                          .map((q) => {
                                'id': q.id,
                                'name': q.name ?? '',
                              })
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteQualities(
                            // userQualities: widget.usersQualities,
                            selectedQualities: selectedQualities,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF869E23),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
