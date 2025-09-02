import 'package:flutter/material.dart';

class CodeSentPage extends StatelessWidget {
  const CodeSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 6),
                  Text('Back', style: TextStyle(fontSize: 16)),
                ],
              ),

              SizedBox(height: 20),

              Text(
                'Code Sent',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text(
                "Check your email or mobile message,\nIf an account 'M&F Play' exists against\nexample123@domain.com / 0300-1234567",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),

              Center(
                child: Image.network(
                  "https://png.pngtree.com/png-clipart/20221016/ourmid/pngtree-3d-flying-email-envelope-png-image_6348681.png",
                  height: 250,
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Sign-In here!",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}