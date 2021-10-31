import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
      {this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure '),
                  content: Text('Are you sure you want to delete $title ?'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  price.toStringAsFixed(1),
                  style: TextStyle(color: Colors.white),
                ),
              )),
            ),
            title: Text(title),
            subtitle: Text("Total: \$" + (quantity * price).toStringAsFixed(2)),
            // trailing: Text('$quantity x'),
            trailing: Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Card(child: Icon(Icons.remove, color: Colors.black)),
                    onPressed: () {
                      cart.changeQuantity(productId, false);
                    },
                  ),
                  Text('$quantity x'),
                  TextButton(
                    child: Card(
                        child: Icon(
                      Icons.add,
                      color: Colors.black,
                    )),
                    onPressed: () {
                      cart.changeQuantity(productId, true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemImage extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItemImage(
      {this.id,
      this.title,
      this.productId,
      this.imageUrl,
      this.quantity,
      this.price});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure '),
                  content: Text('Are you sure you want to delete $title ?'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.black,
              child: FittedBox(
                  child: Image.network(imageUrl)),
            ),
            title: Text(title),
            subtitle: Text("Total: \$" + (quantity * price).toStringAsFixed(2)),
            // trailing: Text('$quantity x'),
            trailing: Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Card(child: Icon(Icons.remove, color: Colors.black)),
                    onPressed: () {
                      cart.changeQuantity(productId, false);
                    },
                  ),
                  Text('$quantity x'),
                  TextButton(
                    child: Card(
                        child: Icon(
                      Icons.add,
                      color: Colors.black,
                    )),
                    onPressed: () {
                      cart.changeQuantity(productId, true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
