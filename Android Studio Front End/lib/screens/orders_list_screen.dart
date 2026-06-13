import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrdersListScreen extends StatefulWidget {
  @override
  _OrdersListScreenState createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {

  List<dynamic> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.getOrders();

      setState(() {
        orders = data;
      });

    } catch (e) {
      print("Load Orders Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load orders ❌")),
      );

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadOrders,
          )
        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(child: Text("No orders found"))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {

          final order = orders[index];

          return Card(
            child: ListTile(

              title: Text(
                  "Customer: ${order['customer_name']}"
              ),

              subtitle: Text(
                  "Book: ${order['book_title']} | Qty: ${order['quantity']} | Total: \$${order['total_price']}"
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ✏️ UPDATE BUTTON
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),

                    onPressed: () {

                      showDialog(
                        context: context,
                        builder: (context) {

                          final nameController =
                          TextEditingController(
                              text: order['customer_name']
                          );

                          final quantityController =
                          TextEditingController(
                              text: order['quantity'].toString()
                          );

                          final totalPriceController =
                          TextEditingController(
                              text: order['total_price'].toString()
                          );

                          return AlertDialog(
                            title: Text("Update Order"),

                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: "Customer Name",
                                  ),
                                ),

                                TextField(
                                  controller: quantityController,
                                  decoration: InputDecoration(
                                    labelText: "Quantity",
                                  ),
                                ),

                                TextField(
                                  controller: totalPriceController,
                                  decoration: InputDecoration(
                                    labelText: "Total Price",
                                  ),
                                ),

                              ],
                            ),

                            actions: [

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),

                              ElevatedButton(
                                onPressed: () async {

                                  await ApiService.updateOrder(
                                    id: order['id'],
                                    bookId: order['book_id'],
                                    customerName:
                                    nameController.text,
                                    quantity:
                                    int.parse(quantityController.text),
                                    totalPrice:
                                    double.parse(totalPriceController.text),
                                  );

                                  Navigator.pop(context);

                                  await loadOrders();
                                },

                                child: Text("Update"),
                              ),

                            ],
                          );
                        },
                      );

                    },
                  ),

                  // 🗑 DELETE BUTTON
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),

                    onPressed: () async {

                      await ApiService.deleteOrder(order['id']);

                      await loadOrders();
                    },
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