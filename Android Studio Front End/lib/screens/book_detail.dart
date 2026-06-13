import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final book =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? "Book Details"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🖼 BOOK IMAGE
              Center(
                child: (book['image_url'] != null &&
                    book['image_url'].toString().isNotEmpty)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book['image_url'],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                      );
                    },
                  ),
                )
                    : const Icon(Icons.book, size: 100),
              ),

              const SizedBox(height: 20),

              // 📘 Title
              Text(
                "Title: ${book['title'] ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ✍️ Author
              Text(
                "Author: ${book['author'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              // 💰 Price
              Text(
                "Price: \$${book['price'] ?? '0'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                book['description'] ?? "No description available",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order',
                      arguments: book,
                    );
                  },
                  child: const Text("Order Now"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}