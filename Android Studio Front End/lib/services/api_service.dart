import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String baseUrl = "http://172.16.163.15:3000";

  // =========================
  // GET TOKEN (JWT)
  // =========================
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // =========================
  // BOOKS (PUBLIC - NO TOKEN)
  // =========================
  static Future<List<dynamic>> getBooks() async {

    final response = await http.get(
      Uri.parse("$baseUrl/books"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load books");
    }
  }

  // =========================
  // CREATE ORDER (PROTECTED)
  // =========================
  static Future<void> createOrder({
    required int bookId,
    required String customerName,
    required int quantity,
    required double totalPrice,
  }) async {

    String? token = await getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/orders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "book_id": bookId,
        "customer_name": customerName,
        "quantity": quantity,
        "total_price": totalPrice,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to place order");
    }
  }

  // =========================
  // GET ORDERS (PUBLIC OR PROTECTED DEPENDING ON YOUR DESIGN)
  // =========================
  static Future<List<dynamic>> getOrders() async {

    final response = await http.get(
      Uri.parse("$baseUrl/orders"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load orders");
    }
  }

  // =========================
  // UPDATE ORDER (PROTECTED)
  // =========================
  static Future<void> updateOrder({
    required int id,
    required int bookId,
    required String customerName,
    required int quantity,
    required double totalPrice,
  }) async {

    String? token = await getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/orders/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "book_id": bookId,
        "customer_name": customerName,
        "quantity": quantity,
        "total_price": totalPrice,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update order");
    }
  }

  // =========================
  // DELETE ORDER (PROTECTED)
  // =========================
  static Future<void> deleteOrder(int id) async {

    String? token = await getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/orders/$id"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete order");
    }
  }
}