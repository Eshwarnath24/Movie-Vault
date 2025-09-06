import 'package:flutter/material.dart';

class changeLanguage extends StatefulWidget {
  final String title;

  const changeLanguage({super.key, required this.title});

  @override
  State<changeLanguage> createState() => _changeLanguageState();
}

class _changeLanguageState extends State<changeLanguage> {
  String _selectedLanguage = "English";

  Widget _buildLanguageOptions(
    String language,
    String flagPath,
    String selectedLanguage,
    Function(String) onChanged,
  ) {
    bool isSelected = language == selectedLanguage;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.white : Colors.white38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            flagPath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(language, style: TextStyle(fontSize: 16))),
          Radio<String>(
            value: language,
            groupValue: selectedLanguage,
            onChanged: (value) {
              onChanged(value!);
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 30),
            _buildLanguageOptions(
              "English",
              "assets/images/india_flag.png",
              _selectedLanguage,
              (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
            _buildLanguageOptions(
              "English (EN)",
              "assets/images/india_flag.png",
              _selectedLanguage,
              (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
