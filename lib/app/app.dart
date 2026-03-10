import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class FlutterAnatomyLabApp extends ConsumerWidget {
  const FlutterAnatomyLabApp({
    super.key,
    this.initialLocation = '/',
  });

  final String initialLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createAppRouter(ref, initialLocation: initialLocation);

    return MaterialApp.router(
      title: 'Flutter Anatomy Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
