// import 'package:flutter/material.dart';
// class LanguageSelectionScreen extends StatefulWidget {
//   final List<String> selectedLanguages;

//   const LanguageSelectionScreen({Key? key, required this.selectedLanguages})
//       : super(key: key);

//   @override
//   _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
// }

// class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
//   final List<String> allLanguages = [
//     'Afar', 'Afrikaans', 'Albanian', 'American Sign Language', 'Amharic',
//     'Arabic', 'Aramaic', 'Armenian', 'Assamese', 'Bengali', 'Bodo', 'Gujarati','Telugu','Tamil'
//     // add more as needed
//   ];

//   late List<String> selected;
//   String searchText = '';

//   @override
//   void initState() {
//     super.initState();
//     selected = [...widget.selectedLanguages];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filtered = allLanguages
//         .where((lang) => lang.toLowerCase().contains(searchText.toLowerCase()))
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your languages'),
//         leading: BackButton(),
//       ),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'What languages do you know?\nSelect up to 5',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Search for a language',
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 setState(() => searchText = value);
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filtered.length,
//               itemBuilder: (_, index) {
//                 final lang = filtered[index];
//                 final isSelected = selected.contains(lang);
//                 return CheckboxListTile(
//                   title: Text(lang),
//                   value: isSelected,
//                   onChanged: (bool? checked) {
//                     setState(() {
//                       if (checked == true) {
//                         if (selected.length < 5) selected.add(lang);
//                       } else {
//                         selected.remove(lang);
//                       }
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, selected);
//               },
//               child: Text('Save (${selected.length}/5)'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//                 backgroundColor: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
