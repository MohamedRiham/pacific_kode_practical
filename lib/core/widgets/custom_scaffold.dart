import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/themes/provider/theme_provider.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? botumNavigation;
  const CustomScaffold({
    super.key,
    required this.title,
    required this.body,
    this.botumNavigation,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,

        actions: [
          Semantics(
            label: themeProvider.isDarkMode ? 'Dark Mode On' : 'Dark Mode Off',
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: botumNavigation,
    );
  }
}
