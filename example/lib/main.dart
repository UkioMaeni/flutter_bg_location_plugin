import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bg_location_plugin/flutter_bg_location_plugin.dart';
import 'package:flutter_bg_location_plugin/models/location_service_meta.dart';
import 'package:flutter_bg_location_plugin/models/location_service_status.dart';
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
  final _flutterBgLocation = FlutterBgLocation();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    serviceIsStarted();
    serviceGetMeta();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Permission.location.request();
    await Permission.notification.request();
    if (Platform.isIOS) {
      await Permission.locationAlways.request();
    }
    return;
  }

  LocationServiceStatus? locationServiceStatus;
  void serviceIsStarted()async{
    locationServiceStatus = await _flutterBgLocation.locationServiceStatus();
    setState(() {});
    
  }

  serviceStart()async{

    // final seconds = int.parse(secondController.text);
    // final hash = hashController.text;
    // final orderId = int.parse(orderIdController.text);

   final result =  await _flutterBgLocation.locationServiceStart(TrackingOptions(seconds: 40, hash: "hash",orderId: 12));
   if(result){
    serviceIsStarted();
    serviceGetMeta();
    secondController.text="";
    hashController.text="";
    orderIdController.text="";
   }
   setState(() {
     
   });

  }

  serviceStop()async{
   final result =  await _flutterBgLocation.locationServiceStop();
   if(result){
    serviceIsStarted();
    serviceGetMeta();
   }
  }

  LocationServiceMeta? meta;
  serviceGetMeta()async{
  meta =  await _flutterBgLocation.locationServiceMeta();
   setState(() {});
  }

  TextEditingController hashController = TextEditingController();
  TextEditingController orderIdController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text("Service Running status",style: TextStyle(fontSize: 25),),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Builder(
                builder: (context) {
                  if(locationServiceStatus==null){
                    return SizedBox(height: 30,width: 30, child: CircularProgressIndicator.adaptive());
                  }
                  return Text(locationServiceStatus!.name,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800),);
                }
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text("Meta:",style: TextStyle(fontSize: 25),),
                  Builder(
                    builder: (context) {
                      if(meta==null){
                        return Text("Loading....",style: TextStyle(fontSize: 20),);
                      }
                      final currMeta = meta!;
                      return Column(
                        children: [
                          Text("tickerSeconds:"+currMeta.tickerSeconds.toString(),style: TextStyle(fontSize: 20),),
                          Text("tickersCount:"+currMeta.tickersCount.toString(),style: TextStyle(fontSize: 20),),
                          Text("hash:"+currMeta.hash.toString(),style: TextStyle(fontSize: 20),),
                          Text("orderId:"+currMeta.orderId.toString(),style: TextStyle(fontSize: 20),)
                        ],
                      );
                    }
                  )
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 100, child: Text("hash: ",style: TextStyle(fontSize: 20),)),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: TextFormField(
                          controller: hashController,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 100, child: Text("orderId: ",style: TextStyle(fontSize: 20),)),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: TextFormField(
                          controller: orderIdController,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      SizedBox(width: 100, child: Text("seconds: ",style: TextStyle(fontSize: 20),)),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all()
                        ),
                        child: TextFormField(
                          controller: secondController,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                if(locationServiceStatus==null){
                  return;
                }
                log("start");
                serviceStart();
              },
              child: Opacity(
                opacity: locationServiceStatus==LocationServiceStatus.stoped?1:0.4,
                child: Container(
                  height: 60,
                  width: 200,
                  alignment: Alignment.center,
                  color: Colors.blueAccent,
                  child: Text("startTracking"),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                if(locationServiceStatus==null){
                  return;
                }
                log("stop");
                serviceStop();
              },
              child: Opacity(
                opacity: locationServiceStatus==LocationServiceStatus.started?1:0.4,
                child: Container(
                  height: 60,
                  width: 200,
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text("stopTracking"),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
