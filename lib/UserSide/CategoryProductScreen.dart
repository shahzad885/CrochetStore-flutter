import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_store/Widgets/ProductCard.dart';
import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$category Products',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: productsCollection
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No products available for this category'),
            );
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return PostCard(
                productId: product.id,
                imageUrl: product['image'],
                name: product['name'],
                description: product['description'] ?? 'No description available',
                price: product['price'],
                brand: product['brand'],
                isCurrentUser: true,  // Assuming the current user owns the product
                onEdit: (context) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('go to home or profile page for editing.'),
                    ),
                  );
                },
                onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('go to home or profile page for deletion.'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
