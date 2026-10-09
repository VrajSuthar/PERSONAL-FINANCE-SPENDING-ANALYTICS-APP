import 'dart:ui';

class AppConst {
  const AppConst._();

  //*==== App ====*/
  static const String appName = 'Finance App';

  //*==== Design (ScreenUtil) ====*/
  static const Size designSize = Size(375, 812);

  //*==== Local storage (Hive boxes & keys) ====*/
  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';
  static const String themeModeKey = 'theme_mode';
}
