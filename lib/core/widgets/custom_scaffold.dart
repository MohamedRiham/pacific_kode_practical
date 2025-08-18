import 'package:pacific_kode_practical/core/widgets/side_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/themes/provider/theme_provider.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool needSideDraw;
  const CustomScaffold({
    super.key,
    required this.title,
    required this.body,
    this.needSideDraw = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: needSideDraw == true ? SideDrawer() : null,
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
    );
  }
}
