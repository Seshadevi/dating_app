import 'package:dating/model/moreabout/work_model.dart';
import 'package:dating/provider/loginProvider.dart';

import 'package:dating/provider/moreabout/workProvider.dart';
import 'package:dating/screens/About_section/add_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loader.dart' as loader;


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

  void _onJobSelected(int? id) async {
    if (selectedJobId == id) return; // Don't update if same job is selected
    
    setState(() {
      selectedJobId = id;
    });

    if (id != null) {
      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text("Updating job selection..."),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // Call update API with the selected job ID
        // await ref.read(workProvider.notifier).up(id);
         try {
                      await ref.read(loginProvider.notifier).updateProfile(
                          image: null,
                          modeid: null,
                          bio: null,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                          jobId:id);
                      print('job updated');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('job updated successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to upload job: $e')),
                      );
                    }
        
        // Show success message
        // if (mounted) {
        //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Job updated successfully"),
        //       backgroundColor: Colors.green,
        //       duration: Duration(seconds: 2),
        //     ),
        //   );
        // }
      } catch (e) {
        // Revert selection on error
        setState(() {
          selectedJobId = null;
        });
        
        // if (mounted) {
        //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text("Failed to update job: $e"),
        //       backgroundColor: const Color.fromARGB(255, 42, 137, 4),
        //       duration: const Duration(seconds: 3),
        //     ),
        //   );
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workList = ref.watch(workProvider);
    // final isLoading = ref.watch(loadingProvider);
    final isLoading = ref.watch(loader.loadingProvider);


    // Get all jobs from the work models
    final List<Data> allJobs = <Data>[];
    for (final workModel in workList) {
      if (workModel.data != null) {
        allJobs.addAll(workModel.data! as List<Data>);

      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Occupation', 
          style: TextStyle(color: Color.fromARGB(255, 130, 118, 118), fontWeight: FontWeight.w600),
        ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You Can Only Show One Job On Your Profile At a Time',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          
          // Jobs List
          Expanded(
            child: isLoading 
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(  Color.fromARGB(255, 42, 137, 4),),
                  ),
                )
              : allJobs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No jobs added yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first job to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: allJobs.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final job = allJobs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8, 
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: selectedJobId == job.id 
                            ? Border.all(color: const Color.fromARGB(255, 42, 137, 4), width: 2)
                            : null,
                        ),
                        child: RadioListTile<int>(
                          value: job.id ?? 0,
                          groupValue: selectedJobId,
                          onChanged: _onJobSelected,
                          activeColor:  const Color.fromARGB(255, 42, 137, 4),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: 8,
                          ),
                          title: Text(
                            job.title ?? 'Unknown Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: job.company != null && job.company!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  job.company!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : null,
                          secondary: selectedJobId == job.id
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: const Color.fromARGB(255, 42, 137, 4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : null,
                        ),
                      );
                    },
                  ),
          ),
          
          // Add Job Button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 42, 137, 4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddJobScreen(),
                    ),
                  );
                  
                  // Refresh the job list if a job was added
                  if (result == true) {
                    ref.read(workProvider.notifier).getWork();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add a Job',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}