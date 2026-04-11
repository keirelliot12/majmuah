import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../di/di.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker =
      instance<InternetConnectionChecker>();

  @override
  Future<bool> get isConnected async {
    // On web, internet_connection_checker causes CORS issues
    // so we assume connection is available or do a simpler check
    if (kIsWeb) {
      // For web, we can assume connected or do a simple navigator.onLine check
      return true; // Assume connected on web to avoid CORS issues
    }

    // For mobile platforms, use the actual connection checker
    try {
      return await _internetConnectionChecker.hasConnection;
    } catch (e) {
      print('Error checking connection: $e');
      return true; // Assume connected on error
    }
  }
}
