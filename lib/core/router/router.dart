import 'package:flutter/material.dart';
import 'package:flutter_camera_view/core/router/bottom_nav_bar.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/pages/camera_view.page.dart';
import 'package:flutter_camera_view/features/gallery/presentation/pages/gallery.page.dart';
import 'package:flutter_camera_view/features/login/presentation/pages/login.page.dart';
import 'package:flutter_camera_view/features/profile/presentation/pages/profile.page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginPages(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          GoRoute(
            path: "/",
            builder: (context, state) => const CameraViewPage(
              key: PageStorageKey("CameraView"),
            ),
          ),
          GoRoute(
            path: "/gallery",
            builder: (context, state) => const GalleryPage(
              key: PageStorageKey("Gallerie"),
            ),
          ),
          GoRoute(
            path: "/profile",
            builder: (context, state) => const ProfilePage(
              key: PageStorageKey("Profile"),
            ),
          )
        ],
      )
    ],
  );
}
