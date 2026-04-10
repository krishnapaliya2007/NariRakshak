import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _timerRunning = false;
  int _selectedMinutes = 30;

  final List<String> _trustedContacts = ['9999999999'];

  final List<int> _timeOptions = [5, 10, 15, 30, 45, 60];

  void _startTimer() {
    setState(() {
      _secondsRemaining = _selectedMinutes * 60;
      _timerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        _sendAlert();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _secondsRemaining = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ You are safe! Timer cancelled.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _sendAlert() async {
    setState(() => _timerRunning = false);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String googleMapsLink =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      String message =
          '⚠️ SAFETY ALERT ⚠️\nI did not confirm my safe arrival!\nMy last known location:\n$googleMapsLink\nPlease check on me immediately!';

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: _trustedContacts.join(','),
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    } catch (e) {
      debugPrint('Error sending alert: $e');
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          'Safety Check-In Timer',
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
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7C4DFF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xFF7C4DFF)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Set a timer. If you don\'t cancel it before it runs out, your trusted contacts will be alerted automatically.',
                        style: TextStyle(
                          color: Color(0xFF7C4DFF),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Timer display
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _timerRunning
                        ? const Color(0xFF7C4DFF)
                        : Colors.grey.shade300,
                    width: 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_timerRunning
                                  ? const Color(0xFF7C4DFF)
                                  : Colors.grey)
                              .withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: _timerRunning
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_secondsRemaining),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                            const Text(
                              'remaining',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_selectedMinutes min',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Time selector
              if (!_timerRunning) ...[
                const Text(
                  'Select duration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: _timeOptions.map((minutes) {
                    bool isSelected = _selectedMinutes == minutes;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMinutes = minutes),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7C4DFF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7C4DFF)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '$minutes min',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Timer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const Text(
                  'Tap below when you arrive safely',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _cancelTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '✅  I am Safe!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
