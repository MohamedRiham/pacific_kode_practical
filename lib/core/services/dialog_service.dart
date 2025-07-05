
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/main.dart';

Future<void> showMessageDialog({required
  String message,
  required String titleText,

  required Function() yesFunction
}) async {
  return await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensures the dialog fits content properly
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text to the left
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ), // Adds spacing between title and message
                Text(message),
              ],
            ),
            actions: [
              TextButton(onPressed: yesFunction, child: const Text('Yes')),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('No'),
              ),
            ],
          );
        },
      ) ;
}
