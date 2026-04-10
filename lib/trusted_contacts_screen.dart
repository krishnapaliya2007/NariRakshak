import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});

  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  List<Map<String, String>> _contacts = [];

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
        _contacts = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trusted_contacts', jsonEncode(_contacts));
  }

  void _addContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Trusted Contact',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Contact Name (e.g. Mom)',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: 'Phone Number (10 digits)',
                prefixIcon: const Icon(Icons.phone),
                prefixText: '+91 ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      phoneController.text.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid name and 10-digit number',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _contacts.add({
                      'name': nameController.text.trim(),
                      'phone': phoneController.text.trim(),
                    });
                  });
                  _saveContacts();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${nameController.text} added as trusted contact!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E8C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Contact'),
        content: Text(
          'Remove ${_contacts[index]['name']} from trusted contacts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _contacts.removeAt(index));
              _saveContacts();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
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
          'Trusted Contacts',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addContact,
        backgroundColor: const Color(0xFFE91E8C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Contact', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E8C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE91E8C).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xFFE91E8C)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'These contacts will be alerted with your location when you trigger SOS or your Check-In Timer expires.',
                        style: TextStyle(
                          color: Color(0xFFE91E8C),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (_contacts.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contacts,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No trusted contacts yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add family or friends who will\nbe alerted in emergencies',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(
                                0xFFE91E8C,
                              ).withOpacity(0.2),
                              child: Text(
                                contact['name']![0].toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFE91E8C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '+91 ${contact['phone']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteContact(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
