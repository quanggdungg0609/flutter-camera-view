import 'package:flutter_camera_view/features/login/presentation/pages/login.page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginPages(),
      ),
    ],
  );
}
