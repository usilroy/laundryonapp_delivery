import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/order.dart';
import '../Provider/orderprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchCustomertoLaundromatOrders(WidgetRef ref) async {
  const url = 'http://68.183.204.241/order/?order_status=laundromart_accepted';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> ordersJson = json.decode(response.body);
    List<Order> orders =
        ordersJson.map((json) => Order.fromJson(json)).toList();

    ref.read(orderListProvider2.notifier).updateOrders(orders);
    print('Response body: ${response.body}');
  } else {
    print('Failed to load orders. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load orders');
  }
}

Future<http.Response> acceptOrder(int orderId, String token) async {
  final url =
      Uri.parse('http://68.183.204.241/driver/pickup/accept-order/$orderId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Order accepted successfully');
  } else {
    print('Failed to accept order: ${response.body}');
  }

  return response;
}
