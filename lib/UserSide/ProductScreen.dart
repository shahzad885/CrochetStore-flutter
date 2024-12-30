import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_store/UserSide/ProductDetailScreen.dart';
import 'package:crochet_store/Widgets/ProductCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochet_store/UserSide/productServices.dart';

class Productscreen extends StatefulWidget {
  const Productscreen({super.key});

  @override
  State<Productscreen> createState() => _ProductscreenState();
}

class _ProductscreenState extends State<Productscreen> {
  final _auth = FirebaseAuth.instance;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search for products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder(
                stream: productServices.productsCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No posts found.'));
                  }

                  final filteredProducts = snapshot.data!.docs.where((product) {
                    final productName =
                        product['name'].toString().toLowerCase();
                    return productName.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        child: PostCard(
                          productId: product.id,
                          imageUrl: product['image'],
                          name: product['name'],
                          price: product['price'],
                          brand: product['brand'],
                          isCurrentUser:
                              product['uid'] == _auth.currentUser?.uid,
                          onEdit: (context) => productServices.showEditDialog(
                            context,
                            product.id,
                            product['name'],
                            product['description'],
                            product['price'],
                            (name, description, price) {
                              productServices.updatePost(
                                product.id,
                                name,
                                description,
                                price,
                              );
                            },
                          ),
                          onDelete: () => productServices.handleDelete(
                            context,
                            product.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
