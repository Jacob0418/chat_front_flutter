import 'dart:io' show Platform;

enum Environment { dev, prod }

class EnvConfig {
  static const Environment current = Environment.dev;

  static String get baseUrl {
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }
}