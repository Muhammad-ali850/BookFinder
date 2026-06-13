import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/book_detail.dart';
import 'screens/order_screen.dart';
import 'screens/orders_list_screen.dart';

import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // CHECK IF USER IS LOGGED IN
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookFinder',

      // 🔥 AUTO LOGIN LOGIC
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If logged in → HomeScreen
          if (snapshot.data == true) {
            return HomeScreen();
          }

          // If not logged in → LoginScreen
          return LoginScreen();
        },
      ),

      // KEEP ROUTES (for navigation inside app)
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/book_detail': (context) => BookDetailScreen(),
        '/order': (context) => OrderScreen(),
        '/orders_list': (context) => OrdersListScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> books = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final data = await ApiService.getBooks();

      setState(() {
        books = data;
      });

    } catch (e) {
      print("Error loading books: $e");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final filteredBooks = books.where((book) {
      final title = book['title'].toString().toLowerCase();
      final query = searchController.text.toLowerCase();

      if (query.isEmpty) {
        return true;
      }

      return title.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("BookFinder"),

        actions: [

          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/orders_list');
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [

            TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: "Search books...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Books",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredBooks.isEmpty
                  ? const Center(
                child: Text("No books found"),
              )
                  : ListView.builder(
                itemCount: filteredBooks.length,

                itemBuilder: (context, index) {

                  final book = filteredBooks[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),

                    child: ListTile(

                      contentPadding: const EdgeInsets.all(10),

                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child: (book['image_url'] != null &&
                            book['image_url']
                                .toString()
                                .isNotEmpty)
                            ? Image.network(
                          book['image_url'],
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.book,
                              size: 50,
                            );
                          },
                        )
                            : const Icon(
                          Icons.book,
                          size: 50,
                        ),
                      ),

                      title: Text(
                        book['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "${book['author']} - \$${book['price']}",
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),

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