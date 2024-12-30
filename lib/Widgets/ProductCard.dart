import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCard extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final String description;
  final String price;
  final String brand;
  final bool isCurrentUser;
  final Function(BuildContext) onEdit;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.name,
    this.description = '',
    required this.price,
    required this.brand,
    required this.isCurrentUser,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (isCurrentUser)
                    Positioned(
                      top: 8,
                      right: 8,
                        child: PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'Edit') {
                          onEdit(context);
                          } else if (value == 'Delete') {
                          onDelete();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        constraints: const BoxConstraints(
                          maxWidth: 70,
                          
                        ),
                        ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Price: PKR $price',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        // color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Brand: $brand',
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
