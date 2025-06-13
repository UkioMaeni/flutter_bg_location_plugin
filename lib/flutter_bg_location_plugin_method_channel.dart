import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bg_location_plugin/models/traking_options.dart';

import 'flutter_bg_location_plugin_platform_interface.dart';

/// An implementation of [FlutterBgLocationPluginPlatform] that uses method channels.
class MethodChannelFlutterBgLocationPlugin extends FlutterBgLocationPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bg_location_plugin');

  @override
  Future<bool?> startTracking(TrackingOptions trackingOptions) async {
    final result = await methodChannel.invokeMethod<bool>('startTracking',{
      "seconds":trackingOptions.seconds,
      "hash":trackingOptions.hash,
    });
    return result;
  }
  @override
  Future<bool?> stopTracking() async {
    final result = await methodChannel.invokeMethod<bool>('stopTracking');
    return result;
  }
}
