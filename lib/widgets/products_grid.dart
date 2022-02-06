import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;

  ProductsGrid(this.showFav);


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = showFav ? productsData.favItems : productsData.items;
    final screenSize = MediaQuery.of(context).size;
    print("screenSize width ${screenSize.width}");
    print("screenSize height ${screenSize.height}");
    final isPortrait = screenSize.width < screenSize.height;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // childAspectRatio: isPortrait ? 2 / 3 : 1,
        childAspectRatio: screenSize.width <= (screenSize.height * 0.65) ? 2 / 3 : 1,
        // crossAxisCount: isPortrait ? 2 : 3,
        crossAxisCount: screenSize.width <= (screenSize.height * 0.65)? 2 : screenSize.width < 800 ? 3 : 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),

      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: ProductItem(),
        );
      },
      itemCount: loadedProducts.length,
    );
  }
}
