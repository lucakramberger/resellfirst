import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/provider/items_provider.dart';

import 'app.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {});
}
