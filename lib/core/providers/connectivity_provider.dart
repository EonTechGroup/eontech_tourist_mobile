import 'package:flutter/material.dart';

enum ConnectivityStatus { online, offline, unknown }

class ConnectivityProvider extends ChangeNotifier {
  static final ConnectivityProvider _instance =
      ConnectivityProvider._internal();
  factory ConnectivityProvider() => _instance;
  ConnectivityProvider._internal();

  ConnectivityStatus _status = ConnectivityStatus.unknown;
  ConnectivityStatus get status => _status;
  bool get isOnline => _status == ConnectivityStatus.online;
  bool get isOffline => _status == ConnectivityStatus.offline;



  void setOnline() {
    if (_status == ConnectivityStatus.online) return;
    _status = ConnectivityStatus.online;
    notifyListeners();
  }

  void setOffline() {
    if (_status == ConnectivityStatus.offline) return;
    _status = ConnectivityStatus.offline;
    notifyListeners();
  }

  void setUnknown() {
    _status = ConnectivityStatus.unknown;
    notifyListeners();
  }

  // ── Show offline snackbar ───────────────────────────────────────────────

  static void showOfflineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'No internet connection',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}