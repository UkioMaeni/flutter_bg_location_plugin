
import 'package:flutter_bg_location_plugin/models/traking_options.dart';

import 'flutter_bg_location_plugin_platform_interface.dart';

class FlutterBgLocationPlugin {
  Future<bool> startTracking(TrackingOptions trackingOptions) async{
    return await FlutterBgLocationPluginPlatform.instance.startTracking(trackingOptions)??false;
  }
  Future<bool> stopTracking() async{
    return await FlutterBgLocationPluginPlatform.instance.stopTracking()??false;
  }
}
