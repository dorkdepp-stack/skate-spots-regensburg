import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/app_shell.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() {
  runApp(const SpotApp());
}

class SpotApp extends StatelessWidget {
  const SpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Spot',
        debugShowCheckedModeBanner: false,
        theme: buildSpotAppTheme(),
        home: const AppShell(),
      ),
    );
  }
}
