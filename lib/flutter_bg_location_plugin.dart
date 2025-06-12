
import 'flutter_bg_location_plugin_platform_interface.dart';

class FlutterBgLocationPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterBgLocationPluginPlatform.instance.getPlatformVersion();
  }
  Future<String?> stopTrack() {
    return FlutterBgLocationPluginPlatform.instance.stopTrack();
  }
}
