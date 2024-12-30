import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider
 extends ChangeNotifier {
  final CollectionReference productsCollection;

  ProductProvider
  (this.productsCollection);

  Future<void> handleDelete(BuildContext context, String productId) async {
    try {
      await productsCollection.doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
      notifyListeners();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: ${error.toString()}')),
      );
    }
  }

  void showEditDialog(
    BuildContext context,
    String docId,
    String name,
    String description,
    String price,
    Function(String, String, String) onSave,
  ) {
    final nameController = TextEditingController(text: name);
    final descController = TextEditingController(text: description);
    final priceController = TextEditingController(text: price);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Post Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(
                  nameController.text,
                  descController.text,
                  priceController.text,
                );
                Navigator.pop(context);
                notifyListeners();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updatePost(
      String docId, String name, String description, String price) async {
    try {
      await productsCollection.doc(docId).update({
        'name': name,
        'description': description,
        'price': price,
      });
      notifyListeners();
    } catch (error) {
      throw Exception('Error updating post: ${error.toString()}');
    }
  }
}
