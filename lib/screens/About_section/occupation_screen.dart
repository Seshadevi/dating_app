import 'package:dating/model/moreabout/work_model.dart';
import 'package:dating/provider/loginProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    final workList = ref.watch(workProvider);

    // Flatten all jobs from different work models
    final List<Data> allJobs = <Data>[];
    for (final workModel in workList) {
      if (workModel.data != null) {
        allJobs.addAll(workModel.data as List<Data>);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Occupation',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'You Can Only Show One Job On Your Profile At a Time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: allJobs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No jobs found.\nAdd your first job above.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: allJobs.length,
                    itemBuilder: (context, index) {
                      final job = allJobs[index];
                      return _buildJobItem(job);
                    },
                  ),
          ),
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
      backgroundColor: Colors.white,
    );
  }

  Widget _buildJobItem(Data job) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Radio<int>(
          value: job.id ?? 0,
          groupValue: selectedJobId,
          onChanged: (int? value) async {
            setState(() {
              selectedJobId = value;
            });
            try {
              await ref.read(loginProvider.notifier).updateProfile(
                    image: null,
                    modeid: null,
                    bio: null,
                    modename: null,
                    prompt: null,
                    qualityId: null,
                    jobId: selectedJobId,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job updated successfully!')),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update job: $e')),
              );
            }
          },
          activeColor: const Color.fromARGB(255, 42, 137, 4),
        ),
        title: Text(
          job.title ?? 'Unknown Job',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: job.company != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Company: ${job.company}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (String action) {
            switch (action) {
              case 'edit':
                _editJob(job);
                break;
              case 'delete':
                _deleteJob(job);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          child: const Icon(Icons.more_vert),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _editJob(Data job) {
    Navigator.pushNamed(
      context,
      '/addoccupation',
      arguments: {
        'id': job.id,
        'title': job.title,
        'company': job.company,
      },
    );
  }

  void _deleteJob(Data job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Job'),
          content: Text(
            'Are you sure you want to delete "${job.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref.read(workProvider.notifier)
                      .deleteLanguages(job.id ?? 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  ref.read(workProvider.notifier).getWork();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
