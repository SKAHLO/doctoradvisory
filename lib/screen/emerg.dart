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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emergency,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quick access to emergency healthcare facilities',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 16),

              // Emergency Service Cards
              _buildServiceCard(
                  context: context,
                  icon: Icons.local_hospital,
                  title: 'FUTA Health Centre',
                  description: 'Primary healthcare facility on campus',
                  onPressed: () {
                    launchUrlString(
                        'https://maps.app.goo.gl/JkZedtfh3H6BF4LZ7');
                  }),

              const SizedBox(height: 16),

              _buildServiceCard(
                context: context,
                icon: Icons.fire_truck,
                title: 'Ondo State Fire Services',
                description: 'Emergency fire and rescue services',
                onPressed: () {
                  launchUrlString(
                      'https://www.google.com/maps/place/Ondo+State+Fire+Service+Headquarters,+Alagbaka/@7.2528246,5.215665,15z/data=!4m6!3m5!1s0x10478f7e490d5adb:0x82869b770fc21ee3!8m2!3d7.2528246!4d5.215665!16s%2Fg%2F11qp36zg4w?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D');
                },
              ),

              const SizedBox(height: 16),

              _buildServiceCard(
                context: context,
                icon: Icons.medical_services,
                title: 'Akure General Hospital',
                description:
                    'Comprehensive medical services and emergency care',
                onPressed: () {
                  launchUrlString(
                      'https://www.google.com/maps/place/Ondo+State+Specialist+Hospital/@7.2421324,5.1235837,13z/data=!4m10!1m2!2m1!1sakure+general+hospital!3m6!1s0x10478f85f7ccbf49:0x9b1a562d53db565c!8m2!3d7.2421324!4d5.1956815!15sChZha3VyZSBnZW5lcmFsIGhvc3BpdGFsWhgiFmFrdXJlIGdlbmVyYWwgaG9zcGl0YWySAQhob3NwaXRhbJoBJENoZERTVWhOTUc5blMwVkpRMEZuU1VOaE0zUlFOSGRuUlJBQuABAA!16s%2Fg%2F1tj0y34m?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D');
                },
              ),

              const SizedBox(height: 32),

              // Emergency Tips Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Emergency Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• Call 911 for emergency services\n'
                        '• Stay calm and provide clear information\n'
                        '• Have your location ready\n'
                        '• Follow first aid protocols if trained',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> launchInBrowserView(String url) async {
  if (!await launchUrl(url as Uri, mode: LaunchMode.inAppBrowserView)) {
    throw Exception('Could not launch $url');
  }
}
