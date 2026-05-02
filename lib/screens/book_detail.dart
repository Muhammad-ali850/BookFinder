import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ FIXED TYPE (important)
    final book =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? "Book Details"),
      ),
      body: SingleChildScrollView( // ✅ prevents overflow
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 📖 Book Cover
              Center(
                child: Image.asset(
                  book['image']!,
                  height: 220,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 📚 Title
              Text(
                "Title: ${book['title']}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ✍️ Author
              Text(
                "Author: ${book['author']}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              // 🏷️ Genre
              Text(
                "Genre: ${book['genre'] ?? "N/A"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              // 📅 Year
              Text(
                "Published: ${book['year'] ?? "N/A"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 15),
              Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                book['description'] ?? "No description available",
                style: TextStyle(fontSize: 16),
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
                  child: Text("Order Now"),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}