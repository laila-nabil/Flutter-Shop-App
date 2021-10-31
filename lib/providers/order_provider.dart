import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.dateTime,
      @required this.products,
      @required this.id,
      @required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  int ordersCount = 0;

  final String authToken;
  final String userId;
  Orders(this.authToken , this._orders,this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<OrderItem> _loadedOrders = [];
      if(extractedData == null){
        ordersCount = 0;
        return;
      }
      ordersCount = extractedData.length;
      extractedData.forEach((key, orderLoaded) {
        _loadedOrders.insert(
            0,
            OrderItem(
                dateTime: DateTime.parse(orderLoaded['dateTime']),
                products: (orderLoaded['products'] as List<dynamic>)
                    .map((item) => CartItem(
                          title: item['title'],
                          price: item['price'],
                          id: item['id'],
                          quantity: item['quantity'],
                        )
                )
                    .toList(),
                id: key,
                amount: orderLoaded['amount']));

        _orders = _loadedOrders.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeNow = DateTime.now();
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    Map<String, dynamic> cartProductMap = {};
    int i = 0;
    cartProducts.forEach((element) {
      cartProductMap.putIfAbsent(
          i.toString(),
          () => {
                'title': element.title,
                'quantity': element.quantity,
                'price': element.price,
                'id': element.id
              });
      i = i + 1;
    });

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'products': cartProductMap,
          'dateTime': timeNow.toString()
        }));
    _orders.insert(
        0,
        OrderItem(
            dateTime: timeNow,
            products: cartProducts,
            id: DateTime.now().toIso8601String(),
            amount: total));
    notifyListeners();
  }

  int get itemCount {
    return orders.length;
  }
}
