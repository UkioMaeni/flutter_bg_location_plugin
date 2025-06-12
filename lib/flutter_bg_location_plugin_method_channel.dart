import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bg_location_plugin_platform_interface.dart';

/// An implementation of [FlutterBgLocationPluginPlatform] that uses method channels.
class MethodChannelFlutterBgLocationPlugin extends FlutterBgLocationPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bg_location_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod('startTracking');
    return version;
  }
  @override
  Future<String?> stopTrack() async {
    final version = await methodChannel.invokeMethod('stopTracking');
    return version;
  }
}
