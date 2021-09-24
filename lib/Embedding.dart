import 'dart:async';

import 'package:flutter/services.dart';

class Embedding {
  static const MethodChannel _channel = const MethodChannel('Embedding');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
