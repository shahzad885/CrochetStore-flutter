import 'package:crochet_store/UserSide/CategorySelectionScreen.dart';
import 'package:crochet_store/UserSide/ProductScreen.dart';
import 'package:crochet_store/UserSide/addProduct.dart';
import 'package:crochet_store/UserSide/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart'; 

class SalomonBottomBarWidget extends StatefulWidget {
  const SalomonBottomBarWidget({super.key});

  @override
  State<SalomonBottomBarWidget> createState() => _SalomonBottomBarWidgetState();
}

class _SalomonBottomBarWidgetState extends State<SalomonBottomBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Productscreen(),
     const AddProduct(),
     const CategorySelectionScreen(),
    const ProfileScreen(),
   
  ];

  // Function to handle tab switching
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body containing the screens
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // SalomonBottomBar navigation
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Switch screen on tap
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Posts'),
            selectedColor: Colors.pink,
          ),
            SalomonBottomBarItem(
            icon: const Icon(Icons.add_box),
            title: const Text('Add Post'),
            selectedColor: Colors.green,
          ),
            SalomonBottomBarItem(
            icon: const Icon(Icons.category),
            title: const Text('Categories'),
            selectedColor: Colors.cyan,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            selectedColor: Colors.purple,
          ),
        
        ],
      ),
    );
  }
}
