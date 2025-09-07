import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/provider/moreabout/educationprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEducationScreen extends ConsumerStatefulWidget {
  const AddEducationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends ConsumerState<AddEducationScreen> {
  final TextEditingController _institutionController = TextEditingController();
  String _selectedYear = "2025";
  int? _editingId; // null = adding mode
  @override
  void initState() {
    super.initState();
    // Initialize with default values
    // We'll get the arguments in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments only once when the route is first built
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && _editingId == null) { // Only set if not already set
      _editingId = args['id'] as int?;
      _institutionController.text = args['institution'] ?? '';
      _selectedYear = args['gradYear'] ?? "2025";
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    super.dispose();
  }

  void _showYearPicker() {
    final years = [for (int y = 2010; y <= 2035; y++) y.toString()];

    final initialIndex = years.indexOf(_selectedYear);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: years.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(years[index]),
                onTap: () {
                  setState(() {
                    _selectedYear = years[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    final institution = _institutionController.text.trim();

    if (institution.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an institution")),
      );
      return;
    }

    try {
      if (_editingId == null) {
        // ADD
        await ref.read(educationProvider.notifier).addEducation(
              institution: institution,
              gradYear: _selectedYear,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education added successfully")),
        );
      } else {
        // UPDATE
        await ref.read(educationProvider.notifier).updateSelectededucation(
              _editingId!,
              institution,
              _selectedYear,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education updated successfully")),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Education" : "Add Education"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Graduation Year: $_selectedYear'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _showYearPicker,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                
                onPressed: _handleSubmit,
                child: Text(isEditing ? "Update" : "Add",style: TextStyle(color: DatingColors.brown,),),
              ),
            )
          ],
        ),
      ),
    );
  }
}