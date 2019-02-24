import 'package:flutter/material.dart';

import 'package:cone/src/flutter/home.dart';
import 'package:cone/src/flutter/add_transaction.dart';

class ConeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cone',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amberAccent,
      ),
      routes: {
        '/': (context) => Home(),
        '/add-transaction': (context) => AddTransaction(),
      },
    );
  }
}
