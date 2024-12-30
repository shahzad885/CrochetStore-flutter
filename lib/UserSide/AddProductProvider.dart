import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddProductProvider with ChangeNotifier {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Uint8List? selectedFileBytes;
  String? selectedFileName;
  bool isUploading = false;
  String? selectedCategory = 'Toys';

  final List<String> categories = [
    'Toys',
    'Scarf',
    'Gloves',
    'Bags',
    'Book Covers',
    'Crocheted Lace',
    'Sweaters',
    'Other',
  ];

  Future<void> pickFile(ImagePicker picker) async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final Uint8List fileBytes = await pickedFile.readAsBytes();
        selectedFileBytes = fileBytes;
        selectedFileName = pickedFile.name;
        notifyListeners();
      } else {
        throw Exception('No image selected');
      }
    } catch (e) {
      throw Exception('Error selecting file: $e');
    }
  }

  Future<String?> uploadToServer() async {
    if (selectedFileBytes == null || selectedFileName == null) {
      throw Exception('Please select an image first');
    }

    try {
      var uri =
          Uri.parse('https://umairpersonalfileuploader-self.vercel.app/upload');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          selectedFileBytes!,
          filename: selectedFileName,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['imageUrl'];
      } else {
        throw Exception('Image upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<void> uploadProduct({
    required String name,
    required String brand,
    required String description,
    required String price,
  }) async {
    if (name.trim().isEmpty ||
        brand.trim().isEmpty ||
        selectedCategory == null ||
        description.trim().isEmpty ||
        price.trim().isEmpty) {
      throw Exception('Please fill all the fields');
    }

    isUploading = true;
    notifyListeners();

    try {
      // Upload image to server
      String? imageUrl = await uploadToServer();

      if (imageUrl == null) {
        throw Exception('Image upload failed, please try again');
      }

      // Add product details to Firestore
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      await _productsCollection.doc(id).set({
        'id': id,
        'uid': uid,
        'image': imageUrl,
        'name': name.trim(),
        'brand': brand.trim(),
        'category': selectedCategory,
        'price': price.trim(),
        'description': description.trim(),
      });
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void resetFields() {
    selectedFileBytes = null;
    selectedFileName = null;
    selectedCategory = 'Toys';
    notifyListeners();
  }
}
