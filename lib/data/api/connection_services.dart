import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionServices {
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
