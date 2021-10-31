import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product_provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  String authToken;
  String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {

    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : "";
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic> map = json.decode(response.body);
      if (map == null) {
        return;
      }
      final urlFav =
          'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/UserFavorites/$userId.json?auth=$authToken';

      final favResponse = await http.get(Uri.parse(urlFav));
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      map.forEach((key, productMap) {
        final newProduct = Product(
          id: key,
          price: productMap['price'],
          imageUrl: productMap['imageUrl'],
          description: productMap['description'],
          title: productMap['title'],
          isFavorite: favData == null ? false : favData[key] ?? false,
        );
        loadedProducts.add(newProduct);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product newItem) async {
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': newItem.title,
            'description': newItem.description,
            'imageUrl': newItem.imageUrl,
            'price': newItem.price,
            'creatorId': userId
          }));
      final newProduct = Product(
          title: newItem.title,
          description: newItem.description,
          imageUrl: newItem.imageUrl,
          price: newItem.price,
          id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      try {
        final response = await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw (error);
      }
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((element) => element.id == id);
    var prod = _items[prodIndex];
    if (prodIndex >= 0) {
      _items.removeAt(prodIndex);
      notifyListeners();
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _items.insert(prodIndex, prod);
        notifyListeners();
        throw HttpException(
            "error : ${response.statusCode} Could not delete item");
      }
      prod = null;
    }
  }

  void updateUser(String token, String id) {
    this.userId = id;
    this.authToken = token;
    notifyListeners();
  }
}
