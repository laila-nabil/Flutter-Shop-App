import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.title,
      @required this.id,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  String authToken;
  // Cart(this.authToken , this._items);

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void changeQuantity(String productId,bool add){
    var addedValue = add == true?   1 : -1;
    if (_items.containsKey(productId) ) {
      if(_items[productId].quantity + addedValue >= 1){
        _items.update(
            productId,
                (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + addedValue));
      }
      else{
        removeItem(productId);
      }
    }
    notifyListeners();
  }

  double get totalAmount{
    double total = 0;
    _items.forEach(
            (key, item) {
              total = total + item.price * item.quantity;});
    return total;
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  int get itemCount{
    return _items.length;
  }

  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
