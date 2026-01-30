import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/resources/resources.dart';

class HomeMenuCard extends StatefulWidget {
  /// Title of the menu item
  final String title;

  /// Icon to display in the card
  final IconData icon;

  /// Color for the icon
  final Color iconColor;

  /// Callback when card is tapped
  final VoidCallback onTap;

  /// Optional custom size for icon
  final double? iconSize;

  /// Optional custom background color
  final Color? backgroundColor;

  /// Optional custom elevation/shadow
  final double elevation;

  /// Optional custom border radius
  final double borderRadius;

  const HomeMenuCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.iconSize,
    this.backgroundColor,
    this.elevation = 2,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  State<HomeMenuCard> createState() => _HomeMenuCardState();
}

class _HomeMenuCardState extends State<HomeMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26), // ~0.1 opacity
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: widget.iconSize ?? AppSize.s50.w,
                  height: widget.iconSize ?? AppSize.s50.w,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withAlpha(26), // ~0.1 opacity
                    borderRadius: BorderRadius.circular(AppSize.s12.r),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: (widget.iconSize ?? AppSize.s50.w) * 0.6,
                  ),
                ),
                SizedBox(height: AppSize.s12.h),

                // Title Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.darkerTeal,
                          fontWeight: FontWeightsManager.semiBold,
                          fontSize: FontSize.s12,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenient variants of HomeMenuCard for common use cases
class HomeMenuCardVariant {
  /// Create a card with a predefined color scheme
  static Widget withColorScheme({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return HomeMenuCard(
      title: title,
      icon: icon,
      iconColor: color,
      onTap: onTap,
    );
  }

  /// Create a card with primary teal color scheme
  static Widget primary({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return HomeMenuCard(
      title: title,
      icon: icon,
      iconColor: AppColors.tealGreen,
      onTap: onTap,
    );
  }

  /// Create a card with secondary yellow-green color scheme
  static Widget secondary({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return HomeMenuCard(
      title: title,
      icon: icon,
      iconColor: AppColors.lemonGreen,
      onTap: onTap,
    );
  }

  /// Create a card with accent dark teal color scheme
  static Widget accent({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return HomeMenuCard(
      title: title,
      icon: icon,
      iconColor: AppColors.darkTeal,
      onTap: onTap,
    );
  }
}
