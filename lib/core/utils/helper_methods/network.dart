import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  /// Checks if the device has an internet connection
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      // Return true if we can't check connectivity to avoid blocking the app
      return true;
    }
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged.map((list) => list.first);
}

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});
