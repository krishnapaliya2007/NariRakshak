import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RedZoneScreen extends StatefulWidget {
  const RedZoneScreen({super.key});

  @override
  State<RedZoneScreen> createState() => _RedZoneScreenState();
}

class _RedZoneScreenState extends State<RedZoneScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(28.6139, 77.2090); // Default Delhi
  bool _locationLoaded = false;

  // Sample red zones — in real app these come from Firestore
  final List<Map<String, dynamic>> _redZones = [
    {
      'location': LatLng(28.6139, 77.2090),
      'label': 'Connaught Place',
      'reports': 12,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.5355, 77.3910),
      'label': 'Noida Sector 18',
      'reports': 8,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.6692, 77.2237),
      'label': 'Kashmere Gate',
      'reports': 9,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.6129, 77.2295),
      'label': 'Paharganj',
      'reports': 15,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.5244, 77.1855),
      'label': 'Dhaula Kuan',
      'reports': 6,
      'color': Colors.orange,
    },
    {
      'location': LatLng(28.6508, 77.2373),
      'label': 'Sadar Bazaar',
      'reports': 7,
      'color': Colors.orange,
    },
    {
      'location': LatLng(28.7041, 77.1025),
      'label': 'Rohini Sector 3',
      'reports': 5,
      'color': Colors.orange,
    },
    {
      'location': LatLng(28.5672, 77.3211),
      'label': 'Shahdara',
      'reports': 11,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.6280, 77.2210),
      'label': 'Karol Bagh',
      'reports': 9,
      'color': Colors.red,
    },
    {
      'location': LatLng(28.5921, 77.0460),
      'label': 'Dwarka Sector 10',
      'reports': 4,
      'color': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever)
        return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationLoaded = true;
      });

      _mapController.move(_currentLocation, 14.0);
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _reportUnsafeArea() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController reasonController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Report Unsafe Area',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You are reporting your current location as unsafe.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Why is this area unsafe? (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _redZones.add({
                    'location': _currentLocation,
                    'label': 'Reported Unsafe Area',
                    'reports': 1,
                    'color': Colors.orange,
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Area reported successfully!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Report',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Red Zone Safety Map',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
            ),
            children: [
              // Base map tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.narirakshak',
              ),

              // Red zone circles
              CircleLayer(
                circles: _redZones.map((zone) {
                  return CircleMarker(
                    point: zone['location'] as LatLng,
                    radius: 100,
                    color: (zone['color'] as Color).withOpacity(0.3),
                    borderColor: zone['color'] as Color,
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),

              // Markers
              MarkerLayer(
                markers: [
                  // Current location marker
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),

                  // Red zone markers
                  ..._redZones.map((zone) {
                    return Marker(
                      point: zone['location'] as LatLng,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.warning_rounded,
                        color: zone['color'] as Color,
                        size: 32,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Legend
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Legend',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: Colors.red.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      const Text('High risk', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: Colors.orange.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      const Text('Medium risk', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      const Text('You', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Report button
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: _reportUnsafeArea,
              icon: const Icon(Icons.flag, color: Colors.white),
              label: const Text(
                'Report This Area as Unsafe',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
