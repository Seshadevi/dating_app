import 'package:dating/provider/signupprocessProviders/causesProvider.dart';
import 'package:dating/screens/completeprofile/favoriteCauses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:dating/model/signupprocessmodels/qualitiesModel.dart';

class CausesScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> usersCauses;
  const CausesScreen({Key? key,required this.usersCauses}) : super(key: key);

  @override
  ConsumerState<CausesScreen> createState() => _CausesScreenState();
}

class _CausesScreenState extends ConsumerState<CausesScreen> {
  final Set<int> selectedIds = {}; // Store selected quality IDs

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
        title: const Text('Select Causes'),
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
                children: causes
                    .where((q) => selectedIds.contains(q.id))
                    .map((q) => Chip(
                          label: Text(q.causesAndCommunities ?? 'Unknown'),
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
              itemCount: causes.length,
              itemBuilder: (context, index) {
                final quality = causes[index];
                final isSelected = selectedIds.contains(quality.id);
                return ListTile(
                  title: Text(quality.causesAndCommunities ?? 'Unnamed'),
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
      userCauses: widget.usersCauses,   // ⬅ previously selected
      selectedCauses: selectedCauses,   // ⬅ just selected
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

  // void _onContinue(List<Data> selectedQualities) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Selected Qualities'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: selectedQualities
  //             .map((q) => Text(q.name ?? 'Unnamed'))
  //             .toList(),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('OK'),
  //         )
  //       ],
  //     ),
  //   );

  //   // You could also navigate to the next screen and pass selectedQualities
  // }
}
