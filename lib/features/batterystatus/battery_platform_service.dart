import 'package:flutter/services.dart';

class BatteryPlatformService {
  static const platform = MethodChannel('com.example.battery/status');
  
  Future<Map<String, dynamic>> getBatteryStatus() async {
    try {
      final result = await platform.invokeMethod('getBatteryStatus');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      return {'error': e.message};
    }
  }
}
