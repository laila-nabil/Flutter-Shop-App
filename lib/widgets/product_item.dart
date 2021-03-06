import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var product = Provider.of<Product>(context, listen: false);
    var cart = Provider.of<Cart>(context, listen: false);
    var authData = Provider.of<Auth>(context, listen: false);
    return LayoutBuilder(builder: (ctx,constraints){
      final footerHeight = constraints.maxHeight * 0.28;
      return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: GridTile(
            child: Hero(
              tag: product.id,
              child: Container(
                color: Colors.white,
                child: Image.network(product.imageUrl),
              ),
            ),
            footer: Container(
                height: footerHeight,
                alignment: Alignment.bottomCenter,
                // color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Consumer<Product>(
                          builder: (ctx, product, child) => IconButton(
                              color: theme.accentColor,
                              onPressed: () async {
                                try {
                                  await product.toggleFav(
                                      authData.token, authData.userId);
                                } catch (error) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                        'Couldn\'t add to Favorite',
                                        style: TextStyle(
                                            color: Theme.of(context).errorColor),
                                      )));
                                }
                              },
                              icon: Icon(product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border))),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 3,
                      child: AutoSizeText(
                        product.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        minFontSize: 10,
                        maxLines: 3,
                        maxFontSize: 30,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: customIconButton(
                          splashColor: theme.accentColor.withOpacity(1),
                          iconColor: theme.accentColor,
                          bgColor: Colors.white,
                          onPressedFunction: () {
                            cart.addItem(product.id, product.price, product.title);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(product.title + ' added to the cart'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cart.changeQuantity(product.id, false);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        product.title +
                                            ' was not added to the cart',
                                        style: TextStyle(color: theme.errorColor),
                                      ),
                                      duration: Duration(seconds: 2),
                                    ));
                                  }),
                            ));
                          },
                          icon: Icons.shopping_cart),
                    ),
                  ],
                )),
          ),
        ),
      );
    });
  }
}

class customIconButton extends StatelessWidget {
  Color splashColor;
  Color iconColor;
  Color bgColor;
  Function onPressedFunction;
  IconData icon;

  customIconButton({this.splashColor,this.bgColor,this.iconColor,this.onPressedFunction,this.icon});
  @override
  Widget build(BuildContext context) {
    return  Material(
        borderRadius: BorderRadius.circular(25),
        color: bgColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          radius: 25,
          onTap: onPressedFunction,
          splashColor: splashColor,
          highlightColor: Colors.grey,
          child: Container(
            width: 34,
            height: 34,
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ));
  }
}

