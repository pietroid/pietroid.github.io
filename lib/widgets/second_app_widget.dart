import 'package:flutter/material.dart';

class SecondAppWidget extends StatelessWidget {
  const SecondAppWidget({super.key});

  final List<Map<String, String>> _posts = const [
    {'user': 'Alice', 'content': 'Enjoying the sunny day!'},
    {'user': 'Bob', 'content': 'Just finished a great book.'},
    {'user': 'Carol', 'content': 'Check out this view from my hike.'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Connect'),
          actions: const [
            IconButton(icon: Icon(Icons.notifications_none), onPressed: null),
            IconButton(icon: Icon(Icons.message_outlined), onPressed: null),
          ],
        ),
        body: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 12),
                        Text(
                          post['user']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(post['content']!),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: null,
                        ),
                        IconButton(
                          icon: Icon(Icons.comment_outlined),
                          onPressed: null,
                        ),
                        IconButton(
                          icon: Icon(Icons.share_outlined),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
