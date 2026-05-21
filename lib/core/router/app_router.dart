import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/sms_login_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/splash/splash_page.dart';
import '../../features/home/home_page.dart';
import '../../features/scan/scan_page.dart';
import '../../features/records/records_page.dart';
import '../../features/analysis_result/analysis_result_page.dart';
import '../../features/ingredient_detail/ingredient_detail_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../models/food_analysis_model.dart';
import '../providers/auth_provider.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String smsLogin = '/sms-login';
  static const String main = '/main';
  static const String home = '/main/home';
  static const String scan = '/main/scan';
  static const String records = '/main/records';
  static const String profile = '/main/profile';
  static const String analysisResult = '/analysis-result';
  static const String ingredientDetail = '/ingredient-detail';
}

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // TODO: 登录暂时跳过，直接进主页
      if (state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.smsLogin) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.smsLogin,
        builder: (context, state) => const SmsLoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scan,
                builder: (context, state) => const ScanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.records,
                builder: (context, state) => const RecordsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.analysisResult,
        builder: (context, state) {
          final analysis = state.extra as FoodAnalysisModel;
          return AnalysisResultPage(analysis: analysis);
        },
      ),
      GoRoute(
        path: AppRoutes.ingredientDetail,
        builder: (context, state) {
          final analysis = state.extra as FoodAnalysisModel;
          return IngredientDetailPage(analysis: analysis);
        },
      ),
    ],
  );
}

