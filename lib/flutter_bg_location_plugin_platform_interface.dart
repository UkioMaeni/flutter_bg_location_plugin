import 'package:flutter_bg_location_plugin/models/traking_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bg_location_plugin_method_channel.dart';

abstract class FlutterBgLocationPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterBgLocationPluginPlatform.
  FlutterBgLocationPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBgLocationPluginPlatform _instance = MethodChannelFlutterBgLocationPlugin();

  /// The default instance of [FlutterBgLocationPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBgLocationPlugin].
  static FlutterBgLocationPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBgLocationPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterBgLocationPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> locationServiceStart(TrackingOptions trackingOptions) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<bool?> locationServiceStop() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<bool?> locationServiceStatus() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<Map<String, dynamic>?> locationServiceMeta() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
