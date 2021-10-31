import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' show Cart;
import '../providers/order_provider.dart';
import '../widgets/cart_item.dart';


class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(15.0),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // OrderButton(),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) {
              return CartItem(
                title: cart.items.values.toList()[index].title,
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              );
            },
            itemCount: cart.itemCount,
          )),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: OrderButtonBottom(),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    setState(() {
      cart.itemCount > 0 ? _isButtonDisabled = false : _isButtonDisabled = true;
    });
    return TextButton(
      onPressed: (_isButtonDisabled || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(cart.items.values.toList(), cart.totalAmount)
                  .then((value) {
                cart.clearCart();
                setState(() {
                  _isLoading = false;
                });
              });
            },
      child: _isLoading ? CircularProgressIndicator() : Text('Order now'),
    );
  }
}

class OrderButtonBottom extends StatefulWidget {
  @override
  _OrderButtonBottomState createState() => _OrderButtonBottomState();
}

class _OrderButtonBottomState extends State<OrderButtonBottom> {
  bool _isLoading = false;
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    setState(() {
      cart.itemCount > 0 ? _isButtonDisabled = false : _isButtonDisabled = true;
    });
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 15, horizontal: 30.0)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.black)),
      onPressed: (_isButtonDisabled || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(cart.items.values.toList(), cart.totalAmount)
                  .then((value) {
                cart.clearCart();
                setState(() {
                  _isLoading = false;
                });
              });
            },
      child:
      _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Proceed To Checkout',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
    );
  }
}
