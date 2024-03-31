import 'package:go_router/go_router.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    // initialLocation: AppRouteNames.splash.path,
    redirect: (context, state) async {
      DomainManager domain = DomainManager();
      var loginInfo = await domain.authenticationLocal.readLoginInfo();
      if (loginInfo?.email != "") {
        return AppRouteNames.home.path;
      }
      return AppRouteNames.login.path;
    },
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: AppRouteNames.login.name,
        path: AppRouteNames.login.path,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: AppRouteNames.signUp.name,
        path: AppRouteNames.signUp.path,
        builder: (context, state) => const SignUpView(),
      ),
    ],
  );
}
