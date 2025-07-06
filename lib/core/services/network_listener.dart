/* This monitors whether the device has an active internet connection.
 If there is no connection, the user is automatically redirected to a page
 where they cannot interact with the app until the connection is restored.*/

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pacific_kode_practical/core/widgets/no_internet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pacific_kode_practical/main.dart';

class NetworkListener {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isOffline = false;

  void checkInternet() {
    subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      bool hasInternet =
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);

      if (!hasInternet) {
        isOffline = true;

        _navigateToNoInternet();
      } else {
        isOffline = false;
        if (navigatorKey.currentContext != null) {
          Navigator.popUntil(
            navigatorKey.currentContext!,
            (route) => route.isFirst,
          ); // Go back to main screen
        }
      }
    });
  }

  void _navigateToNoInternet() {
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => NoInternetPage(
          onRetry: () {
            checkInternet();
          },
        ),
      ),
    );
  }

  void dispose() {
    subscription.cancel();
  }
}
