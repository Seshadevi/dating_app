import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEducationScreen extends StatefulWidget {
  const AddEducationScreen({super.key});

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  final TextEditingController titleController = TextEditingController();
  String selectedYear = "2025";
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    titleController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = titleController.text.trim().isNotEmpty;
    });
  }

  void _showYearPicker() {
    final List<String> years = [
      for (int year = 2020; year <= 2030; year++) year.toString()
    ];

    int initialIndex = years.indexOf(selectedYear);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Graduation year',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedYear = years[index];
                  });
                },
                children: years.map((year) => Center(child: Text(year))).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF9DA200),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  ),
                  child: const Text('Ok', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Education',
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
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Institution',
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: Text('Graduation year: $selectedYear'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showYearPicker,
          ),
          const Divider(height: 1),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        // TODO: Call your API here
                        print('Institution: ${titleController.text}');
                        print('Year: $selectedYear');
                        Navigator.pop(context); // Go back or next screen
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled ? const Color(0xFF9DA200) : Colors.grey.shade400,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
