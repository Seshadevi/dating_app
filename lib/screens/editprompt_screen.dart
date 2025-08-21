
import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';

class PromptEditScreen extends StatefulWidget {
  final String promptText;
  final String initialAnswer;
  final Function(String) onSave;
  
  const PromptEditScreen({
    super.key,
    required this.promptText,
    this.initialAnswer = '',
    required this.onSave,
  });

  @override
  _PromptEditScreenState createState() => _PromptEditScreenState();
}

class _PromptEditScreenState extends State<PromptEditScreen> {
  late TextEditingController _controller;
  int _characterCount = 0;
  final int _maxCharacters = 60;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAnswer);
    _characterCount = widget.initialAnswer.length;
    _controller.addListener(_updateCharacterCount);
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),

              // Prompt text
              Text(
                widget.promptText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // Text input area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffB2D12E), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLength: _maxCharacters,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Let People Know",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    counterText: "", // Hide default counter
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const Spacer(),

              // Bottom row with Cancel, character count, and Done button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    "$_characterCount/$_maxCharacters",
                    style: TextStyle(
                      color: _characterCount > _maxCharacters 
                          ? DatingColors.errorRed
                          :DatingColors.lightgrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: _characterCount > 0 && _characterCount <= _maxCharacters
                        ? () {
                            widget.onSave(_controller.text);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: _characterCount > 0 && _characterCount <= _maxCharacters
                            ? const LinearGradient(
                                colors: [DatingColors.primaryGreen, DatingColors.black],
                              )
                            : LinearGradient(
                                colors: [DatingColors.surfaceGrey!, DatingColors.darkGrey],
                              ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: DatingColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}