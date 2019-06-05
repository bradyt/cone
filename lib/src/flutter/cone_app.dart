import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cone/src/flutter/add_transaction.dart';
import 'package:cone/src/flutter/home.dart';
import 'package:cone/src/flutter/settings_model.dart';
import 'package:cone/src/flutter/settings.dart';

class ConeApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.done:
            return ChangeNotifierProvider(
              builder: (context) => SettingsModel(snapshot.data),
              child: MaterialApp(
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
                  '/settings': (context) => Settings(),
                },
              ),
            );
        }
      },
    );
  }
}
