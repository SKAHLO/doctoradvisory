import 'package:flutter/material.dart';
import 'package:bot_app/screen/chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Morwey Tobi",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/user.png"),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 200, 228),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/surgeon.png",
                      width: 92,
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "How do you feel?",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ChatScreen()),
                            );
                          },
                          child: const Text('Chat WIth a Virtual Doctor'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          height: 35,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: const Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 16),
                height: 64,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(95, 179, 173, 173),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.search,
                      size: 32,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Chat with our Virtual Doctor",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}