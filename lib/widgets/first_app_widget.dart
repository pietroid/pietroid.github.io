import 'package:flutter/material.dart';

class FirstAppWidget extends StatelessWidget {
  const FirstAppWidget({super.key});

  final List<Map<String, String>> _products = const [
    {'name': 'Sneakers', 'price': '\$89'},
    {'name': 'Watch', 'price': '\$129'},
    {'name': 'Backpack', 'price': '\$59'},
    {'name': 'Headphones', 'price': '\$199'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: const [
            IconButton(icon: Icon(Icons.search), onPressed: null),
            IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: null),
          ],
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.image, size: 40)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      product['name']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(product['price']!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Add'),
                    ),
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
