import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:dating/screens/About_section/add_eduction_screen.dart';
// import 'package:dating/provider/educationProvider.dart';
import 'package:dating/model/moreabout/Educationmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  int? selectedEducationId;

  @override
  void initState() {
    super.initState();
    // Fetch education data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(educationProvider.notifier).geteducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final educationState = ref.watch(educationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Education',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/completeprofile'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'You Can Only Show One Education On Your Profile At a Time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          const Divider(),
          
          // Add Education Option
          // ListTile(
          //   title: const Text('Add a Education'),
          //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AddEducationScreen(),
          //       ),
          //     );
          //   },
          // ),
          // const Divider(height: 1),
          
          // Education List
          Expanded(
            child: _buildEducationList(educationState),
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
                      builder: (_) => const AddEducationScreen(),
                    ),
                  );
                  
                  // Refresh the job list if a job was added
                  if (result == true) {
                    ref.read(educationProvider.notifier).geteducation();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add a Education',
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

  Widget _buildEducationList(Educationmodel educationState) {
    if (educationState.data == null || educationState.data!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No education records found.\nAdd your first education above.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: educationState.data!.length,
      itemBuilder: (context, index) {
        final education = educationState.data![index];
        return _buildEducationItem(education);
      },
    );
  }

  Widget _buildEducationItem(Data education) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Radio<int>(
          value: education.id ?? 0,
          groupValue: selectedEducationId,
          onChanged: (int? value) async {
            setState(() {
              selectedEducationId = value;
            });
            
            // Call update API when radio button is selected
            try {
                      await ref.read(loginProvider.notifier).updateProfile(
                          image: null,
                          modeid: null,
                          bio: null,
                          modename: null,
                          prompt: null,
                          qualityId: null,
                          jobId:null,
                          eductionId:selectedEducationId);
                      print('education updated');

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
            if (value != null) {
              _updateEducation(education);
            }
          },
          activeColor: Colors.pink,
        ),
        title: Text(
          education.institution ?? 'Unknown Institution',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Grad Year: ${education.gradYear ?? 'Not specified'}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            // if (education.createdAt != null) ...[
            //   const SizedBox(height: 2),
            //   Text(
            //     'Added: ${_formatDate(education.createdAt!)}',
            //     style: TextStyle(
            //       color: Colors.grey.shade500,
            //       fontSize: 12,
            //     ),
            //   ),
            // ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String action) {
            switch (action) {
              case 'edit':
                _editEducation(education);
                break;
              case 'delete':
                _deleteEducation(education);
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _updateEducation(Data education) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Education'),
          content: Text(
            'Do you want to show "${education.institution}" on your profile?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedEducationId = null;
                });
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performUpdate(education);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _performUpdate(Data education) {
    // Here you would call your update API
    // You'll need to add an update method to your EducationProvider
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected "${education.institution}" as primary education'),
        backgroundColor: Colors.green,
      ),
    );
    
    // TODO: Call the actual update API
    // ref.read(educationProvider.notifier).updateEducation(education.id);
  }

  void _editEducation(Data education) {
    // Navigate to edit screen with education data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEducationScreen(
          // education: education, // Pass education data for editing
        ),
      ),
    ).then((_) {
      // Refresh data when returning from edit screen
      ref.read(educationProvider.notifier).geteducation();
    });
  }

  void _deleteEducation(Data education) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Education'),
          content: Text(
            'Are you sure you want to delete "${education.institution}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Call delete API
                // ref.read(educationProvider.notifier).deleteEducation(education.id);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Education deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}