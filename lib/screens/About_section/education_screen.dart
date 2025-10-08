import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:dating/screens/About_section/add_eduction_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(educationProvider.notifier).geteducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final educationState = ref.watch(educationProvider);
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Education',
          style: TextStyle(color: isDarkMode ? DatingColors.white : DatingColors.black),
        ),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new, color: isDarkMode ? DatingColors.white : DatingColors.black),
          onPressed: () => Navigator.pop(context),
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
                color: DatingColors.lightgrey,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildEducationList(educationState),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isDarkMode ? DatingColors.black : DatingColors.white,
              boxShadow: [
                BoxShadow(
                  color: DatingColors.lightgrey,
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
                  backgroundColor: DatingColors.everqpidColor,
                  foregroundColor: DatingColors.white,
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
                        color: DatingColors.brown
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
    );
  }

  Widget _buildEducationList(Educationmodel educationState) {
    if (educationState.data == null || educationState.data!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No education records found.\nAdd your first education',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DatingColors.lightgrey,
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
        border: Border.all(color: DatingColors.surfaceGrey),
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
            try {
              await ref.read(loginProvider.notifier).updateProfile(
                    image: null,
                    modeid: null,
                    bio: null,
                    modename: null,
                    prompt: null,
                    qualityId: null,
                    jobId: null,
                    educationId: selectedEducationId,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Education updated successfully!')),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update education: $e')),
              );
            }
          },
          activeColor: DatingColors.everqpidColor,
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
                color: DatingColors.lightgrey,
                fontSize: 14,
              ),
            ),
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
                  Icon(Icons.edit, size: 18, color: DatingColors.accentTeal),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete,
                      size: 18, color: DatingColors.brown),
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

  void _editEducation(Data education) {
    Navigator.pushNamed(
  context,
  '/addeductionscreen',
  arguments: {
    'id': education.id,
    'institution': education.institution,
    'gradYear': education.gradYear.toString(),
  },
);

      // if (result == true) {
      //   ref.read(educationProvider.notifier).geteducation();
      // }
    
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
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref.read(educationProvider.notifier)
                  .deleteeducation(education.id ?? 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Education deleted successfully'),
                      backgroundColor: DatingColors.errorRed,
                    ),
                  );
                  ref.read(educationProvider.notifier).geteducation();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: DatingColors.errorRed)),
            ),
          ],
        );
      },
    );
  }
}
