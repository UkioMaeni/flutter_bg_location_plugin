import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bg_location_plugin/flutter_bg_location_plugin.dart';
import 'package:flutter_bg_location_plugin/models/traking_options.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _platformVersion = false;
  final _flutterBgLocationPlugin = FlutterBgLocationPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Permission.location.request();
    await Permission.notification.request();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            GestureDetector(
              onTap: () {
                log("start");
                _flutterBgLocationPlugin.startTracking(TrackingOptions(seconds: 30, hash: "asdasd",orderId: 145));
              },
              child: Container(
                height: 40,
                width: 50,
                color: Colors.amber,
                child: Text("startTracking"),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                _flutterBgLocationPlugin.stopTracking();
              },
              child: Container(
                height: 40,
                width: 50,
                color: Colors.amber,
                child: Text("stopTracking"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
