import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bg_location_plugin/constants/method_names.dart';
import 'package:flutter_bg_location_plugin/models/traking_options.dart';

import 'flutter_bg_location_plugin_platform_interface.dart';

/// An implementation of [FlutterBgLocationPluginPlatform] that uses method channels.
class MethodChannelFlutterBgLocationPlugin extends FlutterBgLocationPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bg_location_plugin');

  @override
  Future<bool?> locationServiceStart(TrackingOptions trackingOptions) async {
    final result = await methodChannel.invokeMethod<bool>(ChannelMethods.LOCATION_SERVICE_START,{
      "seconds":trackingOptions.seconds,
      "hash":trackingOptions.hash,
      "orderId":trackingOptions.orderId,
    });
    return result;
  }
  @override
  Future<bool?> locationServiceStop() async {
    final result = await methodChannel.invokeMethod<bool>(ChannelMethods.LOCATION_SERVICE_STOP);
    return result;
  }
  @override
  Future<bool?> locationServiceStatus() async {
    final result = await methodChannel.invokeMethod<bool>(ChannelMethods.LOCATION_SERVICE_STATUS);
    return result;
  }
  @override
  Future<Map<String, dynamic>?> locationServiceMeta() async {
    final result = await methodChannel.invokeMethod<Map<Object?,Object?>>(ChannelMethods.LOCATION_SERVICE_META);
    print(result.toString());
    return result?.cast<String, dynamic>();
  }
}
