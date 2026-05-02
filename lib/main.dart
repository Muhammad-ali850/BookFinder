import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/book_detail.dart';
import 'screens/order_screen.dart';

void main() {
  runApp(MyApp()); // ✅ FIXED
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookFinder',
      initialRoute: '/login',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/book_detail': (context) => BookDetailScreen(),
        '/order': (context) => OrderScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ✅ UPDATED BOOK DATA (IMPORTANT)
  final List<Map<String, String>> allBooks = [
    {
      "title": "Harry Potter",
      "author": "J.K. Rowling",
      "genre": "Fantasy",
      "year": "1997",
      "image": "assets/images/harry.jpg",
      "description": "A young wizard discovers his magical powers and attends Hogwarts, facing dark forces along the way."
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "genre": "Self-help",
      "year": "2018",
      "image": "assets/images/atomic.jpg",
      "description": "A guide on building good habits and breaking bad ones using small, consistent improvements."
    },
    {
      "title": "Rich Dad Poor Dad",
      "author": "Robert Kiyosaki",
      "genre": "Finance",
      "year": "1997",
      "image": "assets/images/rich.jpg",
      "description": "Explains financial literacy and wealth-building through lessons from two different father figures."
    },
  ];

  List<Map<String, String>> filteredBooks = [];
  final TextEditingController searchController = TextEditingController();
  bool hasSearched = false;

  // ✅ FIXED SEARCH FUNCTION
  void searchBook(String query) {
    final cleanedQuery = query.toLowerCase().trim();

    if (cleanedQuery.isEmpty) {
      setState(() {
        filteredBooks = [];
        hasSearched = false;
      });
      return;
    }

    final results = allBooks.where((book) {
      final title = book["title"]!.toLowerCase();
      return title.contains(cleanedQuery);
    }).toList();

    setState(() {
      filteredBooks = results;
      hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookFinder"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // 🔍 SEARCH FIELD
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search books...",
                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    searchBook(searchController.text);
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onSubmitted: (value) {
                searchBook(value);
              },
            ),

            const SizedBox(height: 20),

            // 📚 RESULTS
            Expanded(
              child: !hasSearched
                  ? const Center(
                child: Text("Search a book to see results"),
              )
                  : filteredBooks.isEmpty
                  ? const Center(
                child: Text("No book found"),
              )
                  : ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];

                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        book["image"]!,
                        width: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                      title: Text(book["title"]!),
                      subtitle: Text(book["author"]!),

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/book_detail',
                          arguments: book,
                        );
                      },
                    ),
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