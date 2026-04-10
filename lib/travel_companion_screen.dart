import 'package:flutter/material.dart';

class TravelCompanionScreen extends StatefulWidget {
  const TravelCompanionScreen({super.key});

  @override
  State<TravelCompanionScreen> createState() => _TravelCompanionScreenState();
}

class _TravelCompanionScreenState extends State<TravelCompanionScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  bool _searched = false;

  final List<Map<String, dynamic>> _mockCompanions = [
    {
      'name': 'Priya S.',
      'from': 'Connaught Place',
      'to': 'Lajpat Nagar',
      'time': '10 mins away',
      'rating': 4.8,
      'trips': 23,
      'verified': true,
      'mode': 'Walking',
      'avatar': 'P',
    },
    {
      'name': 'Anjali M.',
      'from': 'Rajiv Chowk',
      'to': 'South Extension',
      'time': '5 mins away',
      'rating': 4.9,
      'trips': 41,
      'verified': true,
      'mode': 'Metro',
      'avatar': 'A',
    },
    {
      'name': 'Sneha R.',
      'from': 'Patel Chowk',
      'to': 'Hauz Khas',
      'time': '15 mins away',
      'rating': 4.7,
      'trips': 12,
      'verified': true,
      'mode': 'Walking',
      'avatar': 'S',
    },
  ];

  void _searchCompanions() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both locations')),
      );
      return;
    }
    setState(() => _searched = true);
  }

  void _sendRequest(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Request sent to $name!'),
        content: const Text(
          'She will be notified. You can chat once she accepts your request.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Travel Companion',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00BCD4).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified_user, color: Color(0xFF00BCD4)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Women-only verified companions. Free service for walking & metro routes.',
                        style: TextStyle(
                          color: Color(0xFF00BCD4),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Search box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _fromController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        hintText: 'From where?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _toController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Color(0xFFE91E8C),
                        ),
                        hintText: 'Where to?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _searchCompanions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCD4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Find Companions',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (_searched) ...[
                Text(
                  '${_mockCompanions.length} companions found nearby',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ..._mockCompanions.map((companion) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(
                                0xFF00BCD4,
                              ).withOpacity(0.2),
                              child: Text(
                                companion['avatar'],
                                style: const TextStyle(
                                  color: Color(0xFF00BCD4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        companion['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      if (companion['verified'])
                                        const Icon(
                                          Icons.verified,
                                          color: Color(0xFF00BCD4),
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    '⭐ ${companion['rating']} · ${companion['trips']} trips · ${companion['mode']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                companion['time'],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.route,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${companion['from']} → ${companion['to']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat, size: 16),
                                label: const Text('Chat'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF00BCD4),
                                  side: const BorderSide(
                                    color: Color(0xFF00BCD4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _sendRequest(companion['name']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00BCD4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter your route to find\nverified women companions',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
