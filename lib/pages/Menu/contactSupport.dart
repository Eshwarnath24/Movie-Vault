import 'package:flutter/material.dart';

class ContactSupport extends StatefulWidget {
  final String title;

  const ContactSupport({super.key, required this.title});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  Widget _buildContactSupportOptions (IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Material(
          color: Colors.grey.shade900,
          child: InkWell(
            onTap: () {
              print("$title tapped");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            SizedBox(height: 30,),
            _buildContactSupportOptions(Icons.headset_mic_rounded, "Customer Services"),
            _buildContactSupportOptions(Icons.article_rounded, "Contact Form"),
            _buildContactSupportOptions(Icons.facebook, "Facebook"),
          ],
        ),
      ),
    );
  }
}
