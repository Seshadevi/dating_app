import "package:flutter/material.dart";
class PromptSelectionScreen extends StatelessWidget {
  const PromptSelectionScreen({super.key});

  final List<String> prompts = const [
    'If I cooked you dinner it would be',
    'Don’t be mad if I',
    'One thing you need to know about me is',
    'Win me over by',
    'My simple pleasures are',
    "What I'd really like to find is",
    "If I had describe dating me in 3 words",
    "I get out of a bad mood by",
    "My perfect Sunday includes",
    "I'll know we vibe on a date if",
    "my dream is to ",
    "My character flaw is",
    "I'm really proud of"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Pick your first Prompt"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "You can add up to 3 to really show off your personality.",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...prompts.map(
                (prompt) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    prompt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
