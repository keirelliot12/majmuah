import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/resources/resources.dart';

class AppScreenShell extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showBackButton;
  final EdgeInsetsGeometry? padding;

  const AppScreenShell({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showBackButton = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        iconTheme: const IconThemeData(color: AppColors.deepEmerald),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.deepEmerald,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: padding ?? EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
          child: child,
        ),
      ),
    );
  }
}
