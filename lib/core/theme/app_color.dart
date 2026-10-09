// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppColor {
  // ── Brand (your greens, refined) ──
  static const primary_color = Color(0xff0F5C54); // deep emerald teal
  static const dark_green_color = Color(0xff06191E); // near-black ink green
  static const mid_green_color = Color(0xff1FA37A); // vibrant growth green
  static const light_green_color = Color(0xff9FD8B5); // soft mint

  // ── Premium accent (gold = wealth, use sparingly) ──
  static const accent_gold = Color(0xffD4AF37);
  static const accent_gold_soft = Color(0xffF3E3A6);

  // ── Backgrounds & surfaces (dark theme) ──
  static const background_dark = Color(0xff071418);
  static const surface_dark = Color(0xff0E2429);
  static const surface_elevated = Color(0xff143037);
  static const border_dark = Color(0xff1F4249);

  // ── Backgrounds & surfaces (light theme) ──
  static const background_light = Color(0xffF4F8F7);
  static const surface_light = Color(0xffFFFFFF);
  static const border_light = Color(0xffDDE8E5);

  // ── Text ──
  static const text_primary = Color(0xffF2F7F6); // on dark
  static const text_secondary = Color(0xff9DB5B3);
  static const text_muted = Color(0xff6B8785);
  static const text_dark = Color(0xff0B1F23); // on light

  // ── Semantic (finance-specific) ──
  static const profit_color = Color(0xff22C58B); // gains
  static const loss_color = Color(0xffF0546A); // losses
  static const warning_color = Color(0xffF5A524);
  static const info_color = Color(0xff3BA7E0);

  // ── Chart series (distinct, colorblind-friendlier) ──
  static const chart_1 = Color(0xff1FA37A); // green
  static const chart_2 = Color(0xff3BA7E0); // blue
  static const chart_3 = Color(0xffD4AF37); // gold
  static const chart_4 = Color(0xff8B7CF6); // violet
  static const chart_5 = Color(0xffF0546A); // coral red
  static const chart_6 = Color(0xff2DD4D4); // cyan

  // ── Gradients ──
  static const primary_gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xff0F5C54), Color(0xff1FA37A)],
  );

  static const dark_gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff0E2429), Color(0xff06191E)],
  );

  static const gold_gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffD4AF37), Color(0xffF3E3A6)],
  );

  // Chart area fill under a line (use with opacity)
  static Color chartFill(Color c) => c.withValues(alpha: 0.15);
}
