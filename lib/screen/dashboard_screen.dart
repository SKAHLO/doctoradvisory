import 'package:bot_app/screen/chat_screen.dart';
import 'package:bot_app/screen/image_to_the_%20text_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
              child: const Text('Chat'),
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImageToTextScreen()),
                );
              },
              child: const Text('Text to Image'),
            ),
          ],
        ),
      ),
    );
  }
}
