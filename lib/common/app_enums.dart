import 'package:flutter/material.dart';

import '../router/routers.dart' show Routers;
import '../ui/index.dart';
import 'app_colors.dart' show AppColors;

enum DrawerMenu {
  milkLog(
    path: Routers.milkLog,
    title: 'Milk Log',
    icon: Icons.baby_changing_station,
    target: MilkLogPage(),
  ),
  volumeChart(
    path: Routers.volumeChart,
    title: 'Volume Chart',
    icon: Icons.bar_chart,
    target: VolumeChartPage(),
  ),
  feedingCount(
    path: Routers.feedingCount,
    title: 'Feeding Count',
    icon: Icons.countertops,
    target: FeedingCountPage(),
  ),
  feedingHistory(
    path: Routers.feedingHistory,
    title: 'Feeding History',
    icon: Icons.history,
    target: FeedingHistoryPage(),
  );

  final Routers path;
  final String title;
  final IconData icon;
  final Widget target;

  const DrawerMenu({
    required this.path,
    required this.title,
    required this.icon,
    required this.target,
  });
}

enum MilkType {
  mother('Mother'), formula('Formula');

  final String title;

  const MilkType(this.title);
}

/// Snackbar type
enum SnackBarType {
  success(
    AppColors.c2E7D32, // icon + text
    AppColors.cE8F5E9, // background
    Icons.done_outline_rounded,
  ),
  error(
    AppColors.cC62828, // icon + text
    AppColors.cFFEBEE, // background
    Icons.error_outline_rounded,
  ),
  warning(
    AppColors.cEF6C00, // icon + text
    AppColors.cFFF3E0, // background
    Icons.warning_outlined,
  ),
  info(
    AppColors.c0277BD, // icon + text
    AppColors.cE1F5FE, // background
    Icons.info_outline_rounded,
  );

  final Color color;
  final Color bgColor;
  final IconData icon;

  const SnackBarType(this.color, this.bgColor, this.icon);
}