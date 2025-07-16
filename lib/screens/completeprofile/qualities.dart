import 'package:dating/screens/completeprofile/favoritequalities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/signupprocessProviders/qualities.dart';
import 'package:dating/model/signupprocessmodels/qualitiesModel.dart';

class QualitiesScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> usersQualities;
  const QualitiesScreen({Key? key,required this.usersQualities}) : super(key: key);

  @override
  ConsumerState<QualitiesScreen> createState() => _QualitiesScreenState();
}

class _QualitiesScreenState extends ConsumerState<QualitiesScreen> {
  final Set<int> selectedIds = {}; // Store selected quality IDs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(qualitiesProvider.notifier).getQualities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualitiesState = ref.watch(qualitiesProvider);
    final qualities = qualitiesState.data ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Qualities'),
        backgroundColor:const Color.fromARGB(255, 10, 127, 6),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Selected qualities display
          if (selectedIds.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.deepPurple.shade50,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: qualities
                    .where((q) => selectedIds.contains(q.id))
                    .map((q) => Chip(
                          label: Text(q.name ?? 'Unknown'),
                          backgroundColor: Colors.deepPurple.shade100,
                          labelStyle: const TextStyle(color:const Color.fromARGB(255, 10, 127, 6),),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() => selectedIds.remove(q.id));
                          },
                        ))
                    .toList(),
              ),
            ),

          // Qualities list
          Expanded(
            child: ListView.builder(
              itemCount: qualities.length,
              itemBuilder: (context, index) {
                final quality = qualities[index];
                final isSelected = selectedIds.contains(quality.id);
                return ListTile(
                  title: Text(quality.name ?? 'Unnamed'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color:const Color.fromARGB(255, 10, 127, 6),)
                      : const Icon(Icons.circle_outlined),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIds.remove(quality.id);
                      } else {
                        selectedIds.add(quality.id!);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selectedIds.isNotEmpty
                  ? () {
                      final selectedQualities = qualities
    .where((c) => selectedIds.contains(c.id))
    .map((c) => {
          'id': c.id,
          'name': c.name?? '',
        })
    .toList();

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => FavoriteQualities(
      userCauses: widget.usersQualities,   // ⬅ previously selected
      selectedCauses: selectedQualities,   // ⬅ just selected
    ),
  ),
);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 127, 6),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Continue',style:TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue(List<Data> selectedQualities) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selected Qualities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: selectedQualities
              .map((q) => Text(q.name ?? 'Unnamed'))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );

    // You could also navigate to the next screen and pass selectedQualities
  }
}
