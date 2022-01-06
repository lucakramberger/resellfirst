import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/provider/items_provider.dart';
import 'package:resellfirst/screens/home.dart';
import 'package:resellfirst/screens/splashscreen.dart';
import 'package:resellfirst/services/product_service.dart';

import 'models/item_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  _init(BuildContext context) async {
    List<Product> products = await ApiSerivce.getProducts();
    products.forEach((element) async {
      Provider.of<ItemsProvider>(context, listen: false).loadItem(element);
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                title: 'resellfirst',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primaryColor: const Color(0xFF85b7d6),
                    appBarTheme: const AppBarTheme(color: Color(0xFF85b7d6)),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            backgroundColor: Color(0xFF85b7d6),
                            splashColor: Color(0xFF85b7d6))),
                home: Homepage());
          }
          return MaterialApp(
              title: 'resellfirst',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: const Color(0xFF85b7d6),
                appBarTheme: const AppBarTheme(color: Color(0xFF85b7d6)),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: Color(0xFF85b7d6),
                    splashColor: Color(0xFF85b7d6)),
              ),
              home: const SplashScreen());
        });
  }
}
