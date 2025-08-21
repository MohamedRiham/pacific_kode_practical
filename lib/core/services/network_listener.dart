/* This monitors whether the device has an active internet connection.
 If there is no connection, the user is automatically redirected to a page
 where they cannot interact with the app until the connection is restored.*/

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkListener {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ValueNotifier<bool> isOffline = ValueNotifier<bool>(false);

  void checkInternet()  {
    subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      bool hasInternet =
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);

      if (!hasInternet) {
        isOffline.value = true;

      } else {
        isOffline.value = false;
      }
    });
  }

  void dispose() {
    subscription.cancel();
  }
}
