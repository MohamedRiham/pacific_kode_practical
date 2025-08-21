import 'package:get/get.dart';
import 'package:pacific_kode_practical/core/widgets/custom_bottom_navigator.dart';
import 'package:pacific_kode_practical/core/widgets/no_internet.dart';
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      restorationScopeId: 'Root',
      title: 'Pacific Kode Practical',
      navigatorKey: navigatorKey,

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return NetworkGate(child: child ?? const SizedBox.shrink());
      },
      home: const CustomBottomNavigator(),
    );
  }
}

class NetworkGate extends StatefulWidget {
  final Widget child;
  const NetworkGate({super.key, required this.child});

  @override
  State<NetworkGate> createState() => _NetworkGateState();
}

class _NetworkGateState extends State<NetworkGate> {
  final NetworkListener _listener = NetworkListener();

  @override
  void initState() {
    super.initState();
    _listener.checkInternet();
    _listener.isOffline.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_listener.isOffline.value)
          Positioned.fill(
            child: Material(
              color: Colors.white,
              child: NoInternetPage(onRetry: () => _listener.checkInternet()),
            ),
          ),
      ],
    );
  }
}
