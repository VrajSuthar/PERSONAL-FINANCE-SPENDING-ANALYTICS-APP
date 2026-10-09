import 'package:finance_app/core/constants/app_const.dart';
import 'package:finance_app/core/bootstrap/bootstrap.dart';
import 'package:finance_app/core/router/app_routes.dart';
import 'package:finance_app/core/theme/app_theme.dart';
import 'package:finance_app/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() => bootstrap(() => const MyApp());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return ScreenUtilInit(
      designSize: AppConst.designSize,
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoute,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
        );
      },
    );
  }
}
