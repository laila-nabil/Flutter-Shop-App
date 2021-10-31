import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFav(String token,String userId) async{
    final oldStatus = isFavorite;
    var url = 'https://the-shop-app-dfa55-default-rtdb.firebaseio.com/UserFavorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      final response = await http.put(Uri.parse(url),body: json.encode(isFavorite));
      if (response.statusCode >= 400){
        throw HttpException('${response.statusCode} : ${response.body}');
      }
    }catch(error){
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }

    }
}
