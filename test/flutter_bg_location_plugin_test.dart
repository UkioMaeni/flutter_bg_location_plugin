import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bg_location_plugin/flutter_bg_location_plugin.dart';
import 'package:flutter_bg_location_plugin/flutter_bg_location_plugin_platform_interface.dart';
import 'package:flutter_bg_location_plugin/flutter_bg_location_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBgLocationPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBgLocationPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBgLocationPluginPlatform initialPlatform = FlutterBgLocationPluginPlatform.instance;

  test('$MethodChannelFlutterBgLocationPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBgLocationPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterBgLocationPlugin flutterBgLocationPlugin = FlutterBgLocationPlugin();
    MockFlutterBgLocationPluginPlatform fakePlatform = MockFlutterBgLocationPluginPlatform();
    FlutterBgLocationPluginPlatform.instance = fakePlatform;

    expect(await flutterBgLocationPlugin.getPlatformVersion(), '42');
  });
}
