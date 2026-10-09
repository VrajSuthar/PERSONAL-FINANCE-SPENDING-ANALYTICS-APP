import 'package:finance_app/core/constants/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  Box<dynamic> get _box => Hive.box<dynamic>(AppConst.settingsBox);

  //*==== Saved preference is read synchronously (box is opened in bootstrap) ====*/
  @override
  ThemeMode build() {
    final saved = _box.get(AppConst.themeModeKey) as String?;
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _box.put(AppConst.themeModeKey, mode.name);
  }

  Future<void> toggle() => setThemeMode(
    state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
  );
}
