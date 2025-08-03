import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Hospital {
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String type;
  final String description;
  final List<String> services;

  Hospital({
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.description,
    required this.services,
  });

  double distanceFromUser(Position userPosition) {
    return Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      latitude,
      longitude,
    );
  }
}

class HospitalSearchScreen extends StatefulWidget {
  const HospitalSearchScreen({super.key});

  @override
  State<HospitalSearchScreen> createState() => _HospitalSearchScreenState();
}

class _HospitalSearchScreenState extends State<HospitalSearchScreen> {
  Position? _userPosition;
  bool _isLoadingLocation = false;
  List<Hospital> _hospitals = [];
  List<Hospital> _filteredHospitals = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _hasSearchText = false;

  @override
  void initState() {
    super.initState();
    _initializeHospitals();
    _getCurrentLocation();
    _searchController.addListener(_filterHospitals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeHospitals() {
    _hospitals = [
      Hospital(
        name: 'Ondo State Specialist Hospital',
        address: 'Alagbaka, Akure, Ondo State',
        phone: '+234 803 000 0000',
        latitude: 7.2421324,
        longitude: 5.1956815,
        type: 'General Hospital',
        description: 'State-owned tertiary healthcare facility with comprehensive medical services',
        services: ['Emergency Care', 'Surgery', 'Cardiology', 'Maternity', 'Pediatrics', 'ICU'],
      ),
      Hospital(
        name: 'FUTA Health Centre',
        address: 'Federal University of Technology, Akure',
        phone: '+234 803 111 1111',
        latitude: 7.2979412,
        longitude: 5.1451193,
        type: 'Primary Healthcare',
        description: 'University health center providing basic medical services to students and staff',
        services: ['General Medicine', 'First Aid', 'Health Screening', 'Pharmacy'],
      ),
      Hospital(
        name: 'Mother and Child Hospital',
        address: 'Oba Ile Road, Akure, Ondo State',
        phone: '+234 803 222 2222',
        latitude: 7.2571,
        longitude: 5.2058,
        type: 'Specialized Hospital',
        description: 'Specialized healthcare facility focusing on maternal and child health',
        services: ['Maternity', 'Pediatrics', 'Gynecology', 'Neonatal Care', 'Family Planning'],
      ),
      Hospital(
        name: 'Akure Baptist Hospital',
        address: 'Baptist Street, Akure, Ondo State',
        phone: '+234 803 333 3333',
        latitude: 7.2506,
        longitude: 5.2111,
        type: 'Private Hospital',
        description: 'Private healthcare facility with modern medical equipment',
        services: ['General Medicine', 'Surgery', 'Laboratory', 'X-Ray', 'Pharmacy'],
      ),
      Hospital(
        name: 'St. Luke\'s Anglican Hospital',
        address: 'Igbatoro Road, Akure, Ondo State',
        phone: '+234 803 444 4444',
        latitude: 7.2654,
        longitude: 5.1889,
        type: 'Private Hospital',
        description: 'Faith-based hospital providing quality healthcare services',
        services: ['General Medicine', 'Surgery', 'Maternity', 'Dental Care', 'Eye Care'],
      ),
      Hospital(
        name: 'University of Medical Sciences Teaching Hospital',
        address: 'Laje Road, Ondo, Ondo State',
        phone: '+234 803 555 5555',
        latitude: 7.0926,
        longitude: 4.8357,
        type: 'Teaching Hospital',
        description: 'Teaching hospital affiliated with University of Medical Sciences',
        services: ['Emergency Care', 'Surgery', 'Specialist Care', 'Research', 'Training'],
      ),
      Hospital(
        name: 'Federal Medical Centre',
        address: 'Owo, Ondo State',
        phone: '+234 803 666 6666',
        latitude: 7.1964,
        longitude: 5.5868,
        type: 'Federal Hospital',
        description: 'Federal government healthcare facility with tertiary services',
        services: ['Emergency Care', 'Surgery', 'Cardiology', 'Neurology', 'Oncology'],
      ),
      Hospital(
        name: 'Poly Clinic',
        address: 'Adesida Road, Akure, Ondo State',
        phone: '+234 803 777 7777',
        latitude: 7.2445,
        longitude: 5.1914,
        type: 'Private Hospital',
        description: 'Multi-specialty private clinic with experienced doctors',
        services: ['General Medicine', 'Specialist Consultation', 'Laboratory', 'Pharmacy'],
      ),
      Hospital(
        name: 'First City Hospital',
        address: 'Benin-Akure Road, Akure, Ondo State',
        phone: '+234 803 888 8888',
        latitude: 7.2334,
        longitude: 5.1778,
        type: 'Private Hospital',
        description: 'Modern private hospital with advanced medical facilities',
        services: ['Emergency Care', 'Surgery', 'Cardiology', 'Dialysis', 'ICU'],
      ),
      Hospital(
        name: 'Sunrise Hospital',
        address: 'Ilesha-Akure Road, Akure, Ondo State',
        phone: '+234 803 999 9999',
        latitude: 7.2198,
        longitude: 5.1667,
        type: 'Private Hospital',
        description: 'Private healthcare facility with focus on quality patient care',
        services: ['General Medicine', 'Surgery', 'Maternity', 'Laboratory', 'Radiology'],
      ),
    ];
    _filteredHospitals = List.from(_hospitals);
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return; // Prevent multiple simultaneous calls
    
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location permission is granted
      var permission = await Permission.location.status;
      if (permission.isDenied) {
        permission = await Permission.location.request();
      }

      if (permission.isGranted) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showLocationServiceDialog();
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _userPosition = position;
          _sortHospitalsByDistance();
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      _showErrorDialog('Error getting location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _sortHospitalsByDistance() {
    if (_userPosition != null) {
      _filteredHospitals.sort((a, b) {
        double distanceA = a.distanceFromUser(_userPosition!);
        double distanceB = b.distanceFromUser(_userPosition!);
        return distanceA.compareTo(distanceB);
      });
    }
  }

  void _filterHospitals() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _hasSearchText = _searchController.text.isNotEmpty;
      _filteredHospitals = _hospitals.where((hospital) {
        bool matchesSearch = hospital.name.toLowerCase().contains(query) ||
            hospital.address.toLowerCase().contains(query) ||
            hospital.services.any((service) => service.toLowerCase().contains(query));
        
        bool matchesFilter = _selectedFilter == 'All' || hospital.type == _selectedFilter;
        
        return matchesSearch && matchesFilter;
      }).toList();

      if (_userPosition != null) {
        _sortHospitalsByDistance();
      }
    });
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to find nearby hospitals.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text('Location permission is required to find nearby hospitals. You can still browse all hospitals.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Hospitals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search hospitals, services...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _hasSearchText
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterHospitals();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All',
                      'General Hospital',
                      'Private Hospital',
                      'Specialized Hospital',
                      'Teaching Hospital',
                      'Primary Healthcare',
                    ].map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                              _filterHospitals();
                            });
                          },
                          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Location Status
          if (_isLoadingLocation)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Getting your location...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

          // Hospitals List
          Expanded(
            child: _filteredHospitals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredHospitals.length,
                    itemBuilder: (context, index) {
                      return _buildHospitalCard(_filteredHospitals[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hospitals found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    String? distance;
    if (_userPosition != null) {
      double distanceInMeters = hospital.distanceFromUser(_userPosition!);
      distance = _formatDistance(distanceInMeters);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hospital.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (distance != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                distance,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hospital.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              hospital.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hospital.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  hospital.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Services
            Text(
              'Services:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: hospital.services.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      launchUrlString('tel:${hospital.phone}');
                    },
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      launchUrlString(
                        'https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}',
                      );
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
