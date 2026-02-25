import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../ui/index.dart';
import 'app_transition.dart' show TransitionPage, PageTransitionType;
import 'routers.dart';
import 'navigator_observer.dart';

final kRoot = GlobalKey<NavigatorState>(debugLabel: 'kRoot');

class AppRouter {
  // Private constructor
  AppRouter._internal();

  // Singleton instance
  static final AppRouter _instance = AppRouter._internal();

  // Factory constructor to return the same instance
  factory AppRouter() => _instance;

  // Getter for the router instance
  GoRouter get router => _router;

  // Lazy initialization of the router
  late final GoRouter _router = GoRouter(
    initialLocation: Uri.base.toString(),
    navigatorKey: kRoot,
    debugLogDiagnostics: true,
    redirectLimit: 10,
    observers: [NavObserver()],
    routes: [
      _dashboard,
      _milk,
      _volumeChart,
      _feedingCount,
      _history,
    ],
  );
}

// Child routers
GoRoute get _dashboard => GoRoute(
  path: Routers.dashboard.routerPath,
  name: Routers.dashboard.routerName,
  pageBuilder: (context, state) => TransitionPage(
    child: const DashBoardPage(),
    transitionType: PageTransitionType.slideFromBottomFade
  )
);

GoRoute get _milk => GoRoute(
  path: Routers.milkLog.routerPath,
  name: Routers.milkLog.routerName,
  pageBuilder: (context, state) => TransitionPage(
    child: const MilkLogPage(),
    transitionType: PageTransitionType.slideFromBottomFade
  ),
  routes: [
    GoRoute(
      path: Routers.addMilk.routerPath,
      name: Routers.addMilk.routerName,
      pageBuilder: (context, state) => TransitionPage(
        child: const MilkAddPage(),
        transitionType: PageTransitionType.slideFromTopFade
      ),
    ),
    GoRoute(
      path: Routers.updateMilk.routerPath,
      name: Routers.updateMilk.routerName,
      pageBuilder: (context, state) => TransitionPage(
        child: MilkUpdatePage(id: state.pathParameters['id']!),
        transitionType: PageTransitionType.slideFromTopFade,
      ),
    ),
  ]
);

GoRoute get _volumeChart => GoRoute(
  path: Routers.volumeChart.routerPath,
  name: Routers.volumeChart.routerName,
  pageBuilder: (context, state) => TransitionPage(
    child: const VolumeChartPage(),
    transitionType: PageTransitionType.slideFromBottomFade
  )
);

GoRoute get _feedingCount => GoRoute(
  path: Routers.feedingCount.routerPath,
  name: Routers.feedingCount.routerName,
  pageBuilder: (context, state) => TransitionPage(
    child: const FeedingCountPage(),
    transitionType: PageTransitionType.slideFromBottomFade
  )
);

GoRoute get _history => GoRoute(
  path: Routers.feedingHistory.routerPath,
  name: Routers.feedingHistory.routerName,
  pageBuilder: (context, state) => TransitionPage(
    child: const FeedingHistoryPage(),
    transitionType: PageTransitionType.slideFromBottomFade
  )
);

final appRouter = AppRouter();






