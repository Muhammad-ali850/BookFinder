import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController =
  TextEditingController(text: "1");

  bool isLoading = false;

  double totalPrice = 0;

  void calculateTotal(double pricePerBook) {
    int quantity = int.tryParse(quantityController.text) ?? 0;

    setState(() {
      totalPrice = quantity * pricePerBook;
    });
  }

  Future<void> placeOrder(
      int bookId,
      double pricePerBook,
      ) async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      String customerName = nameController.text.trim();
      int quantity = int.parse(quantityController.text.trim());

      double finalTotalPrice = quantity * pricePerBook;

      await ApiService.createOrder(
        bookId: bookId,
        customerName: customerName,
        quantity: quantity,
        totalPrice: finalTotalPrice,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully ✅"),
        ),
      );

      Future.delayed(
        const Duration(milliseconds: 300),
            () {
          Navigator.pop(context, true);
        },
      );

    } catch (e) {

      print("Order Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to place order ❌"),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final book =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int bookId = book['id'];

    final double pricePerBook =
        double.tryParse(book['price'].toString()) ?? 0;

    if (totalPrice == 0) {
      totalPrice = pricePerBook;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Order"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Price Per Book: \$${pricePerBook.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),

                onChanged: (_) {
                  calculateTotal(pricePerBook);
                },
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.green.shade50,

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => placeOrder(
                    bookId,
                    pricePerBook,
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Place Order"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}