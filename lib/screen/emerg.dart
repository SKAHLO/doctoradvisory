import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EmergencyServices extends StatefulWidget {
  const EmergencyServices({super.key});

  @override
  State<EmergencyServices> createState() => _EmergencyServicesState();
}

class _EmergencyServicesState extends State<EmergencyServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const Text(
                  'Click on the buttons below to access a desired service'),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the first URL
                  launchUrlString(
                      'https://www.google.com/maps/place/Health+Centre,+FUTA/@7.2979465,5.1425444,17z/data=!3m1!4b1!4m6!3m5!1s0x10478eceb497630b:0xa4f072e3caead59!8m2!3d7.2979412!4d5.1451193!16s%2Fg%2F11c52_bj4w?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D');
                },
                child: const Text('FUTA HEALTH CENTRE'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the second URL
                  launchUrlString(
                      'https://www.google.com/maps/place/Ondo+State+Fire+Service+Headquarters,+Alagbaka/@7.2528246,5.215665,15z/data=!4m6!3m5!1s0x10478f7e490d5adb:0x82869b770fc21ee3!8m2!3d7.2528246!4d5.215665!16s%2Fg%2F11qp36zg4w?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D');
                },
                child: const Text('ONDO STATE FIRE SERVICES'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the third URL
                  launchUrlString(
                      'https://www.google.com/maps/place/Ondo+State+Specialist+Hospital/@7.2421324,5.1235837,13z/data=!4m10!1m2!2m1!1sakure+general+hospital!3m6!1s0x10478f85f7ccbf49:0x9b1a562d53db565c!8m2!3d7.2421324!4d5.1956815!15sChZha3VyZSBnZW5lcmFsIGhvc3BpdGFsWhgiFmFrdXJlIGdlbmVyYWwgaG9zcGl0YWySAQhob3NwaXRhbJoBJENoZERTVWhOTUc5blMwVkpRMEZuU1VOaE0zUlFOSGRuUlJBQuABAA!16s%2Fg%2F1tj0y34m?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D');
                },
                child: const Text('AKURE GENERAL HOSPITAL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> launchInBrowserView(String url) async {
  if (!await launchUrl(url as Uri, mode: LaunchMode.inAppBrowserView)) {
    throw Exception('Could not launch $url');
  }
}
