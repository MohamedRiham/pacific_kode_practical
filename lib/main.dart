import 'package:get/get.dart';
import 'package:pacific_kode_practical/core/widgets/custom_bottom_navigator.dart';
import 'package:pacific_kode_practical/presentation/getx/user_getx.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pacific_kode_practical/core/themes/provider/theme_provider.dart';
import 'package:pacific_kode_practical/core/themes/constants/themes.dart';
import 'package:pacific_kode_practical/core/services/network_listener.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
 Get.put(UserGetX());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()..initDatabase()),
      ],
      child: const MyApp(),
    ),
  );
  NetworkListener().checkInternet();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      restorationScopeId: 'R1',
      title: 'Pacific Kode Practical',
      navigatorKey: navigatorKey,

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,

      home: const CustomBottomNavigator(),
    );
  }
}
