import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/firebase_options.dart';
import 'package:movies_task/router_config.dart';

void main() {
  l.capture<void>(
    () => runZonedGuarded<void>(
      () async {
        final binding =
            WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        await DI.initialize();
        runApp(const MainApp());
        binding.allowFirstFrame();
      },
      (error, stackTrace) {
        l.e(error, stackTrace);
      },
    ),
    LogOptions(
      handlePrint: true,
      printColors: Platform.isAndroid,
      outputInRelease: false,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Key builderKey = GlobalKey();
    return MaterialApp.router(
      routerConfig: routerConfig,
      builder:
          (context, child) => MediaQuery(
            key: builderKey,
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child ?? const SizedBox.shrink(),
          ),
    );
  }
}
