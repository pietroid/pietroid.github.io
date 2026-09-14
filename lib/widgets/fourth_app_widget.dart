import 'package:flutter/material.dart';

class FourthAppWidget extends StatefulWidget {
  const FourthAppWidget({super.key});

  @override
  State<FourthAppWidget> createState() => _FourthAppWidgetState();
}

class _FourthAppWidgetState extends State<FourthAppWidget> {
  final TextEditingController _controller = TextEditingController(
    text: 'Start typing your note here...',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: const [
            IconButton(icon: Icon(Icons.undo), onPressed: null),
            IconButton(icon: Icon(Icons.redo), onPressed: null),
          ],
        ),
        body: Column(
          children: [
            Material(
              elevation: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.format_bold),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_italic),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_underline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type here...',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
