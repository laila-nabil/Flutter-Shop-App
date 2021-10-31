import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';

import '../providers/order_provider.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(builder: (ctx, ordersProvider, child) {
                  return ordersProvider.itemCount >= 1
                      ? ListView.builder(
                    itemBuilder: (ctx, i) {
                      var products = ordersProvider.orders[i].products;
                      return OrderItem(ordersProvider.orders[i]);
                    },//
                    itemCount: ordersProvider.itemCount,
                  )
                      : Center(
                    child: Text('No orders added!'),
                  );
                });
              }
            }
          },
        )
    );
  }
}
