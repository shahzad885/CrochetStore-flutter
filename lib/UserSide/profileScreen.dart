import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_store/UserSide/ProductDetailScreen.dart';
import 'package:crochet_store/UserSide/productServices.dart';
import 'package:crochet_store/UI/Auth/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    final CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final ProductProvider productProvider = ProductProvider(productsCollection);

    return Scaffold(
      appBar: AppBar(
          actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginscreen()),
                );
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Details Section
            FutureBuilder<DocumentSnapshot>(
              future: usersCollection.doc(currentUser?.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User details not found.'));
                }

                final user = snapshot.data!;
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user['name'] ?? 'Name not available',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user['email'] ?? 'Email not available',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // User Products Section
            Expanded(
              child: StreamBuilder(
                stream: productsCollection
                    .where('uid', isEqualTo: currentUser?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No products added by you.'),
                    );
                  }

                  final products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['image'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          ),
                          title: Text(
                          product['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          subtitle: Text(
                          'Price: pkr ${product['price']}',
                          style: GoogleFonts.roboto(
                            color: Colors.grey.shade600,
                          ),
                          ),
                          trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              productProvider.showEditDialog(
                              context,
                              product.id,
                              product['name'],
                              product['description'],
                              product['price'],
                              (newName, newDesc, newPrice) async {
                                // Update product in Firestore
                                await productsCollection
                                  .doc(product.id)
                                  .update({
                                'name': newName,
                                'description': newDesc,
                                'price': newPrice,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post updated successfully'),
                                ),
                                );
                              },
                              );
                            },
                            ),
                            IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              productProvider.handleDelete(
                                context, product.id);
                            },
                            ),
                          ],
                          ),
                          onTap: () {
                          // Navigate to ProductDetailScreen when the product is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              productId: product.id,
                            ),
                            ),
                          );
                          },
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
