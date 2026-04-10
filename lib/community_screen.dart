import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _isAnonymous = false;

  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Anonymous',
      'isAnonymous': true,
      'time': '2 hours ago',
      'content':
          'I was followed while walking home last night near Lajpat Nagar metro. Please be careful in that area after 9pm. I reported it on the Red Zone map.',
      'likes': 24,
      'comments': 8,
      'tag': 'Safety Alert',
      'tagColor': Colors.red,
    },
    {
      'author': 'Priya S.',
      'isAnonymous': false,
      'time': '5 hours ago',
      'content':
          'Thank you NariRakshak community! Used the travel companion feature today for the first time and felt so much safer. We need more women supporting each other like this! 💪',
      'likes': 56,
      'comments': 12,
      'tag': 'Experience',
      'tagColor': Colors.green,
    },
    {
      'author': 'Anonymous',
      'isAnonymous': true,
      'time': '1 day ago',
      'content':
          'For anyone who has faced harassment — you are not alone. Please report it. Your story matters and can help protect others.',
      'likes': 89,
      'comments': 23,
      'tag': 'Support',
      'tagColor': Colors.purple,
    },
    {
      'author': 'Meera K.',
      'isAnonymous': false,
      'time': '2 days ago',
      'content':
          'Tip: Always share your live location with at least one trusted contact when travelling alone at night. The check-in timer feature here is a lifesaver!',
      'likes': 43,
      'comments': 6,
      'tag': 'Safety Tip',
      'tagColor': Colors.blue,
    },
  ];

  void _showNewPostDialog() {
    final TextEditingController postController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
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
                    'Share with the community',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: postController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Share your experience, tip, or ask for support...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Switch(
                        value: _isAnonymous,
                        onChanged: (val) {
                          setModalState(() => _isAnonymous = val);
                          setState(() => _isAnonymous = val);
                        },
                        activeColor: const Color(0xFFE91E8C),
                      ),
                      const Text('Post anonymously'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (postController.text.isNotEmpty) {
                          setState(() {
                            _posts.insert(0, {
                              'author':
                                  _isAnonymous ? 'Anonymous' : 'You',
                              'isAnonymous': _isAnonymous,
                              'time': 'Just now',
                              'content': postController.text,
                              'likes': 0,
                              'comments': 0,
                              'tag': 'My Post',
                              'tagColor': const Color(0xFFE91E8C),
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post shared with community!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E8C),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Share Post',
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
            );
          },
        );
      },
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
          'Support Community',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E8C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_user,
                    color: Color(0xFFE91E8C), size: 14),
                SizedBox(width: 4),
                Text(
                  'Women Only',
                  style: TextStyle(
                    color: Color(0xFFE91E8C),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewPostDialog,
        backgroundColor: const Color(0xFFE91E8C),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'Share',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: post['isAnonymous']
                            ? Colors.grey.shade300
                            : const Color(0xFFE91E8C).withOpacity(0.2),
                        child: Icon(
                          post['isAnonymous']
                              ? Icons.person_outline
                              : Icons.person,
                          color: post['isAnonymous']
                              ? Colors.grey
                              : const Color(0xFFE91E8C),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['author'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              post['time'],
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
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (post['tagColor'] as Color)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post['tag'],
                          style: TextStyle(
                            color: post['tagColor'] as Color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Content
                  Text(
                    post['content'],
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Actions
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _posts[index]['likes']++;
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.favorite_border,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${post['likes']}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${post['comments']}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post reported for review'),
                            ),
                          );
                        },
                        child: const Icon(Icons.flag_outlined,
                            size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}