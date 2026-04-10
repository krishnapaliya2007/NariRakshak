import 'package:flutter/material.dart';

class AuthorityDashboardScreen extends StatefulWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  State<AuthorityDashboardScreen> createState() =>
      _AuthorityDashboardScreenState();
}

class _AuthorityDashboardScreenState extends State<AuthorityDashboardScreen> {
  List<Map<String, dynamic>> zones = [
    {"name": "Connaught Place", "reports": 12, "status": "Active"},
    {"name": "Karol Bagh", "reports": 8, "status": "Active"},
    {"name": "Shahdara", "reports": 6, "status": "Active"},
  ];

  void markResolved(int index) {
    setState(() {
      zones[index]["status"] = "Resolved";
    });
  }

  int get resolvedCount => zones.where((z) => z["status"] == "Resolved").length;

  int get totalReports =>
      zones.fold(0, (sum, z) => sum + (z["reports"] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authority Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔥 HEADER
            const Text(
              "Authority Control Panel",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Monitor and resolve high-risk zones",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 🔥 STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard("Zones", "${zones.length}", Colors.red),
                _statCard("Resolved", "$resolvedCount", Colors.green),
                _statCard("Reports", "$totalReports", Colors.orange),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 TITLE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hot Zones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 LIST
            Expanded(
              child: ListView.builder(
                itemCount: zones.length,
                itemBuilder: (context, index) {
                  final zone = zones[index];
                  final isResolved = zone["status"] == "Resolved";

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // LEFT SIDE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                zone["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Reports: ${zone["reports"]}"),
                            ],
                          ),

                          // RIGHT SIDE (FIXED OVERFLOW)
                          SizedBox(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  zone["status"],
                                  style: TextStyle(
                                    color: isResolved
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: isResolved
                                        ? null
                                        : () => markResolved(index),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: isResolved
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                    child: const Text(
                                      "Resolve",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 STAT CARD
  Widget _statCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
