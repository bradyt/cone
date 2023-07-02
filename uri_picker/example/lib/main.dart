import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uri_picker/uri_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _uri;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> pickUri() async {
    String? uri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      uri = await UriPicker.pickUri();
    } on PlatformException {
      rethrow;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted || uri == null) return;

    setState(() {
      _uri = uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uri Picker example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(_uri ?? 'No uri yet'),
                ElevatedButton(
                  child: const Text('Pick URI'),
                  onPressed: () async {
                    await pickUri();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
