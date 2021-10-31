import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context).settings.arguments;
    final product = productsData.findById(productId);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.network(
              product.imageUrl,
              // color: Theme.of(context).scaffoldBackgroundColor,
              fit: BoxFit.cover,
              // fit: BoxFit.fitHeight,
              height: screenHeight * 0.5,
              width: double.infinity,
            ),
            Column(
              children: [
                Container(
                  height: screenHeight * 0.5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Container(
                    color: Colors.white,
                    height: screenHeight * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, right: 40.0, left: 40.0, bottom: 15),
                          child: Text(
                            product.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40.0, bottom: 20, right: 40.0),
                          child: Text(
                            product.description,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, left: 40.0, bottom: 20, right: 40.0),
                          child: Row(
                            children: [
                              Text(
                                '\$ ${product.price}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 28),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
            // SizedBox(
            //   height: 15,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "\$ ${product.price}",
            //     style: TextStyle(color: Colors.blueGrey, fontSize: 25),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "${product.description}",
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/products_provider.dart';
//
// class ProductDetailScreen extends StatelessWidget {
//   static const routeName = '/product-detail';
//
//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<Products>(context, listen: false);
//     final productId = ModalRoute.of(context).settings.arguments;
//     final product = productsData.findById(productId);
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: screenHeight * 0.4,
//           pinned: true,
//           //flexibleSpace
//           flexibleSpace: LayoutBuilder(
//             builder: (ctx, constraints) {
//               var height = constraints.maxHeight;
//               return FlexibleSpaceBar(
//                 title: Text(product.title),
//                 background: Hero(
//                     tag: productId,
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Image.network(
//                           product.imageUrl,
//                           fit: BoxFit.cover,
//                           height: screenHeight * 0.4,
//                           width: double.infinity,
//                         ),
//                         Container(
//                           height: height * 0.2,
//                           color: Colors.black45,
//                         ),
//                       ],
//                     )),
//               );
//             },
//           ),
//         ),
//         SliverList(
//             //delegate tells how to animate
//             delegate: SliverChildListDelegate([
//           SizedBox(
//             height: 15,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "\$ ${product.price}",
//               style: TextStyle(color: Colors.blueGrey, fontSize: 25),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "${product.description}",
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           //to make page scrollable,add sizedBox
//           SizedBox(
//             height: 800,
//           )
//         ]))
//       ],
//     ));
//   }
// }
