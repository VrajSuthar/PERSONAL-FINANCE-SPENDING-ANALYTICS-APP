import 'dart:async';

import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/core/network/auth_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Everything that must be ready before the first frame.
///
/// Put all initial app data/setup here (storage, services, SDKs, preloaded
/// settings) and `main()` just hands the root widget to [bootstrap].
/// Each step is a small function so it can be reordered or skipped without
/// touching the others.
Future<void> bootstrap(Widget Function() builder) async {
  //*==== Zone catches async errors that escape Flutter's own handlers ====*/
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    _initErrorHandling();
    await _initSystemChrome();
    await _initStorage();

    final container = ProviderContainer();
    _initNetwork(container);

    await _loadInitialData(container);

    runApp(UncontrolledProviderScope(container: container, child: builder()));
  }, (error, stack) => _reportError(error, stack));
}

//*========================================== Steps ==========================================*/

void _initErrorHandling() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _reportError(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack);
    return true;
  };
}

Future<void> _initSystemChrome() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> _initStorage() async {
  await Hive.initFlutter();

  //*==== Open boxes needed synchronously by the first screen here ====*/
  await Hive.openBox<dynamic>('auth_box');
}

void _initNetwork(ProviderContainer container) {
  //*==== Wire once a session provider exists, e.g. container.read(sessionProvider.notifier).signOut() ====*/
  ApiClient.onSessionExpired = () async {
    await TokenStorage.clear();
  };
}

/// Preload anything the first screen reads (cached user, theme, flags, ...).
Future<void> _loadInitialData(ProviderContainer container) async {
  // e.g. await container.read(settingsProvider.future);
}

void _reportError(Object error, StackTrace? stack) {
  if (kDebugMode) debugPrint('❌ Unhandled error: $error\n$stack');
  // Hook up Crashlytics/Sentry here.
}
