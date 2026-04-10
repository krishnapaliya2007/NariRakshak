import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  bool _isSending = false;
  String _statusMessage = 'Press the button to send SOS';
  Color _statusColor = Colors.grey;
  List<String> _trustedContacts = [];

  static const _smsChannel = MethodChannel('com.example.narirakshak/sms');

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString('trusted_contacts');
    if (contactsJson != null) {
      final List<dynamic> decoded = jsonDecode(contactsJson);
      setState(() {
        _trustedContacts = decoded.map((e) => e['phone'].toString()).toList();
      });
    }
  }

  Future<void> _sendDirectSMS(String phone, String message) async {
    try {
      await _smsChannel.invokeMethod('sendSMS', {
        'phone': phone,
        'message': message,
      });
    } catch (e) {
      debugPrint('SMS error: $e');
    }
  }

  // 🔥 NEW: ADAPTIVE SOS FUNCTION
  Future<void> _startAdaptiveSOS() async {
    int fastCount = 0;
    int slowCount = 0;

    // 🔴 FAST PHASE (every 20 sec)
    Timer.periodic(const Duration(seconds: 20), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String link =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      String message = '🚨 EMERGENCY! Live Location:\n$link';

      for (String phone in _trustedContacts) {
        await _sendDirectSMS(phone, message);
      }

      fastCount++;

      if (fastCount >= 5) {
        timer.cancel();

        // 🟡 SLOW PHASE (every 2.5 min)
        Timer.periodic(const Duration(minutes: 2, seconds: 30), (timer2) async {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          String link =
              'https://maps.google.com/?q=${position.latitude},${position.longitude}';

          String message = '📍 UPDATE: Live Location:\n$link';

          for (String phone in _trustedContacts) {
            await _sendDirectSMS(phone, message);
          }

          slowCount++;

          if (slowCount >= 6) {
            timer2.cancel();

            setState(() {
              _statusMessage = 'Tracking completed.';
              _statusColor = Colors.green;
              _isSending = false;
            });
          }
        });
      }
    });
  }

  Future<void> _sendSOS() async {
    if (_trustedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ No trusted contacts added! Please add contacts first.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
      _statusMessage = 'Getting your location...';
      _statusColor = Colors.orange;
    });

    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _statusMessage = 'Location permission denied!';
          _statusColor = Colors.red;
          _isSending = false;
        });
        return;
      }

      PermissionStatus smsPermission = await Permission.sms.request();

      if (!smsPermission.isGranted) {
        setState(() {
          _statusMessage = 'SMS permission denied!';
          _statusColor = Colors.red;
          _isSending = false;
        });
        return;
      }

      setState(() {
        _statusMessage = '🚨 SOS Activated\nLive tracking started...';
      });

      // 🔥 START ADAPTIVE TRACKING
      await _startAdaptiveSOS();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _statusColor = Colors.red;
        _isSending = false;
      });
    }
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
          'SOS Emergency',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: _statusColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              GestureDetector(
                onTap: _isSending ? null : _sendSOS,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isSending
                          ? [Colors.grey, Colors.grey.shade400]
                          : [const Color(0xFFE91E8C), const Color(0xFFAD1457)],
                    ),
                  ),
                  child: _isSending
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 64,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'SOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 60),

              Text(
                _trustedContacts.isEmpty
                    ? 'No contacts added yet!'
                    : '${_trustedContacts.length} contacts will receive live updates',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
