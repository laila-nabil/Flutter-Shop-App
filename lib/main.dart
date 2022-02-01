// Run Debug Web:
// fvm flutter run -d chrome --web-renderer html
//
// Release Build Web:
// fvm flutter build web --dart-define api_key=key --web-renderer html --release

// Web setup
// in windows powershell as admin, run : fvm use stable
// a .fvm folder is added with shortcut
// get full path of shortcut and add to project as flutter path instead of original path
// fvm flutter config --enable-web in terminal/windows powershell as admin
//to build : fvm flutter build web --dart-define api_key=key
//to init hosting on firebase:
//set up project at firebase
//from terminal:
// firebase init hosting
// use build/web as public directory, single web page, not overwrite
// fvm flutter build web --dart-define api_key=key
// firebase deploy --only hosting

//to run on web
// fvm flutter run -d edge --dart-define api_key=key

//to reupload
// fvm flutter build web --dart-define api_key=key
// firebase deploy --only hosting

//to add another url
//firebase hosting:sites:create sitename
//firebase hosting:channel:create sitename
//firebase hosting:channel:deploy flutter-shop
//in firebase.json
// {
// "hosting": {
// "site": "sitename",
//
// "public": "public",
// ...
// }
// }
//firebase deploy --only hosting:sitename

//firebase deploy --only hosting:flutter-shop

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './providers/auth_provider.dart';
import './screens/auth_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/order_provider.dart';
import './helpers/custom_route.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', [], ''),
            update: (ctx, auth, previousProducts) =>
                previousProducts..updateUser(auth.token, auth.userId)),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId)),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        const accentColor =  Color(0xff131014);
        const bgColor  = Color(0xfff3f2f5);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              scaffoldBackgroundColor: bgColor,

              appBarTheme: AppBarTheme(
                  elevation: 0.0,
                  backgroundColor: bgColor,
                  // textTheme: TextTheme(
                  //     headline6: Theme.of(context)
                  //         .textTheme
                  //         .headline6
                  //         .copyWith(color: accentColor)),
                  titleTextStyle: TextStyle(
                      color: accentColor),
                iconTheme: IconThemeData(color :accentColor ),
                actionsIconTheme: IconThemeData(color : accentColor)

              ),
              //to set custom route to all routes including namedRoutes
              pageTransitionsTheme: PageTransitionsTheme(
                  //builders is a map {platform : PageTransitionBuilder }
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  }),
              primaryColor: Color(0xffd8d7db),
              accentColor:Colors.deepOrange,
              buttonColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, tryAutoLoginSnapshot) =>
                      tryAutoLoginSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        );
      }),
    );
  }
}
