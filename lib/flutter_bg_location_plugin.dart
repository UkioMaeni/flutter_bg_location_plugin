
import 'package:flutter_bg_location_plugin/models/location_service_meta.dart';
import 'package:flutter_bg_location_plugin/models/location_service_status.dart';
import 'package:flutter_bg_location_plugin/models/traking_options.dart';

import 'flutter_bg_location_plugin_platform_interface.dart';

class FlutterBgLocation {
  Future<bool> locationServiceStart(TrackingOptions trackingOptions) async{
    final result = await FlutterBgLocationPluginPlatform.instance.locationServiceStart(trackingOptions);
    return result??false;
  }
  Future<bool> locationServiceStop() async{
    final result = await FlutterBgLocationPluginPlatform.instance.locationServiceStop();
    return result??false;
  }
  Future<LocationServiceStatus> locationServiceStatus() async{
    final isStarted = await FlutterBgLocationPluginPlatform.instance.locationServiceStatus();
    switch(isStarted){
      case null: return LocationServiceStatus.stoped;
      case false: return LocationServiceStatus.stoped;
      case true: return LocationServiceStatus.started;
    }
  }
  Future<LocationServiceMeta> locationServiceMeta() async{
    final meta  = await FlutterBgLocationPluginPlatform.instance.locationServiceMeta();
    print(meta.toString());
    if(meta==null){
      return LocationServiceMeta.nullable();
    }
    return LocationServiceMeta.fromMap(meta);
  }
}
