import 'package:dating/provider/moreabout/workProvider.dart';
import 'package:dating/screens/About_section/add_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OccupationScreen extends ConsumerStatefulWidget {
  const OccupationScreen({super.key});

  @override
  ConsumerState<OccupationScreen> createState() => _OccupationScreenState();
}

class _OccupationScreenState extends ConsumerState<OccupationScreen> {
  int? selectedJobId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(workProvider.notifier).getWork());
  }

  // void _onJobSelected(int? id) async {
  //   setState(() {
  //     selectedJobId = id;
  //   });

  //   final work = ref.read(workProvider);
  //   final provider = ref.read(workProvider.notifier);

  //   if (id != null && work.title != null && work.company != null) {
  //     try {
  //       await provider.addwork(work.title, work.company);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Job updated successfully")),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to update job: $e")),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final work = ref.watch(workProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Occupation', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/completeprofile'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You Can Only Show One Job On Your Profile At a Time',
                style: TextField.materialMisspelledTextStyle
                // TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
          const Divider(),
          // if (work.title != null && work.title!.isNotEmpty)
          //   RadioListTile<int>(
          //     value: work.id ?? 0,
          //     groupValue: selectedJobId,
          //     onChanged: _onJobSelected,
          //     title: Text(work.title ?? ''),
          //     subtitle: Text(work.company ?? ''),
          //     activeColor: Colors.pink,
          //   )
          // else
          //   const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          //     child: Text('No job added yet.'),
          //   ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddJobScreen()),
                  );
                },
                child:  Text(
                  'Add a Job',
                  style: TextField.materialMisspelledTextStyle
                  // TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
