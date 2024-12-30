import 'package:crochet_store/UserSide/AddProductProvider.dart';
import 'package:crochet_store/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController brandController = TextEditingController();
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        foregroundColor: Colors.black,
      ),
      body: Consumer<AddProductProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        await provider.pickFile(picker);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: provider.selectedFileBytes == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pets_outlined,
                                    size: 50, color: Colors.grey),
                                Text('Tap to select an image',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : Image.memory(provider.selectedFileBytes!,
                              fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(
                      hintText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: provider.selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Category',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (String? newCategory) {
                      provider.selectedCategory = newCategory;
                      provider.notifyListeners();
                    },
                    items: provider.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 5,
                    controller: descController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      hintText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Custombutton(
                    color: Colors.grey,
                    buttonText: 'Add Product',
                    onTap: () async {
                      try {
                        await provider.uploadProduct(
                          name: nameController.text,
                          brand: brandController.text,
                          description: descController.text,
                          price: priceController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added successfully')),
                        );
                        nameController.clear();
                        brandController.clear();
                        descController.clear();
                        priceController.clear();
                        provider.resetFields();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    loading: provider.isUploading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}