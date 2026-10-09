import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// A Google Fonts factory such as `GoogleFonts.poppins` or `GoogleFonts.geist`.
typedef GoogleFontBuilder = TextStyle Function({TextStyle? textStyle});

/// The app's one text widget.
///
/// Pass just the Google Font and it is applied on top of every style set here:
///
/// ```dart
/// CommonText('Balance', googleFont: GoogleFonts.poppins, fontSize: 18, fontWeight: FontWeight.w600)
/// ```
///
/// geist is the default font. Set [CommonText.defaultGoogleFont] once (e.g. in
/// `main`) to change it app-wide; a per-widget [googleFont] overrides it.
class CommonText extends StatelessWidget {
  const CommonText(
    this.text, {
    super.key,
    this.googleFont,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.backgroundColor,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.shadows,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.textScaler,
    this.semanticsLabel,
    this.padding,
    this.onTap,
    this.useScreenUtil = true,
    this.children,
  });

  /// Font used by every [CommonText] that doesn't pass its own [googleFont].
  static GoogleFontBuilder? defaultGoogleFont = GoogleFonts.geist;

  final String text;

  /// Only the Google Font, e.g. `GoogleFonts.poppins`. All other style
  /// properties below are layered onto it.
  final GoogleFontBuilder? googleFont;

  /// Base style; the individual properties below override it.
  final TextStyle? style;

  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final Color? backgroundColor;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final List<Shadow>? shadows;

  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final String? semanticsLabel;

  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  /// Scales [fontSize] (`.sp`), [letterSpacing]/[wordSpacing] (`.w`) and
  /// [padding] (`.w` horizontal, `.h` vertical) with flutter_screenutil.
  /// Turn off for fixed sizes.
  final bool useScreenUtil;

  /// Inline spans appended after [text], e.g. a tappable "Sign up" link.
  final List<InlineSpan>? children;

  /// Convenience for an inline tappable span inside [children].
  static TextSpan link(String text, {required VoidCallback onTap, TextStyle? style}) =>
      TextSpan(text: text, style: style, recognizer: TapGestureRecognizer()..onTap = onTap);

  double? _scaleW(double? value) => value == null || !useScreenUtil ? value : value.w;

  EdgeInsetsGeometry _scalePadding(EdgeInsetsGeometry value) {
    if (!useScreenUtil) return value;
    if (value is EdgeInsets) {
      return EdgeInsets.fromLTRB(value.left.w, value.top.h, value.right.w, value.bottom.h);
    }
    if (value is EdgeInsetsDirectional) {
      return EdgeInsetsDirectional.fromSTEB(value.start.w, value.top.h, value.end.w, value.bottom.h);
    }
    return value;
  }

  TextStyle _resolveStyle(BuildContext context) {
    final base = (style ?? DefaultTextStyle.of(context).style).copyWith(
      fontSize: fontSize == null ? null : (useScreenUtil ? fontSize!.sp : fontSize),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      backgroundColor: backgroundColor,
      letterSpacing: _scaleW(letterSpacing),
      wordSpacing: _scaleW(wordSpacing),
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      shadows: shadows,
    );

    final font = googleFont ?? defaultGoogleFont;
    return font == null ? base : font(textStyle: base);
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolveStyle(context);

    Widget result = children == null
        ? Text(
            text,
            style: resolved,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
            softWrap: softWrap,
            textDirection: textDirection,
            textScaler: textScaler,
            semanticsLabel: semanticsLabel,
          )
        : Text.rich(
            TextSpan(text: text, children: children),
            style: resolved,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
            softWrap: softWrap,
            textDirection: textDirection,
            textScaler: textScaler,
            semanticsLabel: semanticsLabel,
          );

    if (padding != null) result = Padding(padding: _scalePadding(padding!), child: result);
    if (onTap != null) result = GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: result);

    return result;
  }
}
