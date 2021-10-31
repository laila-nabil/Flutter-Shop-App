import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';
import '../helpers/custom_route.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
          ),
          Divider(),
          CustomListTile(
            icon: Icon(Icons.shop),
            text: 'The Shop',
            onTap: ()=>  Navigator.of(context).pushReplacementNamed('/'),
          ),
          CustomListTile(
            icon: Icon(Icons.credit_card),
            text: 'Orders',
            onTap: (){
              Navigator.of(context).pushReplacement(CustomRoute(
                builder: (ctx) => OrdersScreen(),
              ));
            },
          ),
          CustomListTile(
            icon: Icon(Icons.edit),
            text: 'My Products',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor)),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); //though no error,added just in case
                  Navigator.of(context).pushReplacementNamed(
                      '/'); //to make sure it goes to home where the main auth logic
                  Provider.of<Auth>(context, listen: false).logout();
                },
                child: Text('Logout')),
          )
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onTap;

  CustomListTile({this.icon,this.text,this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 17),
      ),
      onTap: onTap,
    );
  }
}
