import 'package:finance_app/core/constants/app_images.dart';
import 'package:amazing_icons/amazing_icons.dart';
import 'package:finance_app/core/router/routes_names.dart';
import 'package:finance_app/shared/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashIntroScreen extends StatelessWidget {
  const SplashIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030806),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(AppImages.splashIntroBg, fit: BoxFit.cover, alignment: Alignment.topCenter),

            // Dark overlay for a cinematic look
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    const Color(0xFF06130D).withValues(alpha: 0.25),
                    const Color(0xFF030806).withValues(alpha: 0.88),
                    const Color(0xFF030806),
                  ],
                  stops: const [0.0, 0.35, 0.68, 1.0],
                ),
              ),
            ),

            // Subtle emerald glow
            Positioned(
              top: 0.42.sh,
              left: -0.25.sw,
              child: Container(
                height: 0.5.sh,
                width: 1.1.sw,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withValues(alpha: 0.09),
                ),
              ),
            ),

            // Bottom content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand / category label
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 7.r,
                            width: 7.r,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF34D399)),
                          ),
                          SizedBox(width: 8.w),
                          CommonText(
                            "SMARTER FINANCE STARTS HERE",
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms),

                    const Spacer(),

                    // Headline
                    CommonText(
                          "Modern Tools\nfor Modern",
                          fontSize: 42,
                          textAlign: TextAlign.left,
                          color: Colors.white,
                          height: 1.12,
                          fontWeight: FontWeight.w600,
                        )
                        .animate()
                        .fadeIn(duration: 700.ms, delay: 150.ms)
                        .slideY(begin: 0.15, end: 0, duration: 700.ms, delay: 150.ms),

                    CommonText(
                          "Finance.",
                          fontSize: 46,
                          textAlign: TextAlign.left,
                          color: const Color(0xFF34D399),
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                        )
                        .animate()
                        .fadeIn(duration: 700.ms, delay: 300.ms)
                        .slideY(begin: 0.15, end: 0, duration: 700.ms, delay: 300.ms),

                    SizedBox(height: 18.h),

                    CommonText(
                      "Take control of your money with "
                      "intuitive tools designed around you.",
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ).animate().fadeIn(duration: 700.ms, delay: 450.ms),

                    SizedBox(height: 32.h),

                    // CTA button
                    Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push(RoutesNames.login_screen);
                            },
                            borderRadius: BorderRadius.circular(24.r),
                            child: Ink(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF34D399), Color(0xFF10B981)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.22),
                                    blurRadius: 28.r,
                                    offset: Offset(0, 10.h),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(
                                    "Explore Your Finances",
                                    fontSize: 16,
                                    color: const Color(0xFF03130B),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Container(
                                    height: 38.r,
                                    width: 38.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF071A11).withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      AmazingIconBroken.arrowRight,
                                      color: const Color(0xFF03130B),
                                      size: 22.r,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 700.ms, delay: 550.ms)
                        .slideY(begin: 0.2, end: 0, duration: 700.ms, delay: 550.ms),

                    SizedBox(height: 18.h),

                    Center(
                      child: CommonText(
                        "YOUR MONEY. YOUR FUTURE.",
                        fontSize: 10,
                        color: Colors.white38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
