import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'sos_screen.dart';
import 'checkin_screen.dart';
import 'redzone_screen.dart';
import 'travel_companion_screen.dart';
import 'community_screen.dart';
import 'trusted_contacts_screen.dart';
import 'app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔴 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE91E8C), Color(0xFFAD1457)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.appName,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              AppStrings.tagline,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            // 🌐 LANGUAGE TOGGLE
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  AppStrings.isHindi = !AppStrings.isHindi;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  AppStrings.isHindi ? 'EN' : 'HI',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // CONTACTS
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TrustedContactsScreen(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.contacts,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🚨 SOS BUTTON
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SOSScreen()),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Color(0xFFE91E8C),
                              size: 44,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppStrings.sosButton,
                              style: const TextStyle(
                                color: Color(0xFFE91E8C),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppStrings.sosTap,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.features,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _FeatureCard(
                      icon: Icons.timer,
                      title: AppStrings.checkIn,
                      subtitle: "",
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CheckInScreen()),
                      ),
                    ),
                    _FeatureCard(
                      icon: Icons.map,
                      title: AppStrings.redZone,
                      subtitle: "",
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RedZoneScreen()),
                      ),
                    ),
                    _FeatureCard(
                      icon: Icons.group,
                      title: AppStrings.community,
                      subtitle: "",
                      color: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CommunityScreen()),
                      ),
                    ),
                    _FeatureCard(
                      icon: Icons.directions_walk,
                      title: AppStrings.companion,
                      subtitle: "",
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TravelCompanionScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
