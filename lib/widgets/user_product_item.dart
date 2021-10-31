import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Are you sure '),
                          content:
                              Text('Are you sure you want to delete $title ?'),
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
                        )).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                        'Deleting failed',
                        style: TextStyle(color: theme.errorColor),
                      )));
                    }
                  }
                });
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
