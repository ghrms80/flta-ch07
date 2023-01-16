import 'package:ch07_routes_and_navigation/models/models.dart';
import 'package:ch07_routes_and_navigation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // 1
  final AppStateManager appStateManager;
  // 2
  final ProfileManager profileManager;
  // 3
  final GroceryManager groceryManager;

  AppRouter(
    this.appStateManager,
    this.profileManager,
    this.groceryManager,
  );

  // 4
  late final router = GoRouter(
    // 5
    debugLogDiagnostics: true,
    // 6
    refreshListenable: appStateManager,
    // 7
    initialLocation: '/login',
    // 8
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'home',
        // 1
        path: '/:tab',
        builder: (context, state) {
          // 2
          final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
          // 3
          return Home(
            key: state.pageKey,
            currentTab: tab,
          );
        },
        // 4
        routes: [
          GoRoute(
            name: 'item',
            // 1
            path: 'item/:id',
            builder: (context, state) {
              // 2
              final itemId = state.params['id'] ?? '';
              // 3
              final item = groceryManager.getGroceryItem(itemId);
              // 4
              return GroceryItemScreen(
                originalItem: item,
                onCreate: (item) {
                  // 5
                  groceryManager.addItem(item);
                },
                onUpdate: (item) {
                  // 6
                  groceryManager.updateItem(item);
                },
              );
            },
          ),
          GoRoute(
            name: 'profile',
            // 1
            path: 'profile',
            builder: (context, state) {
              // 2
              final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
              // 3
              return ProfileScreen(
                user: profileManager.getUser,
                currentTab: tab,
              );
            },
            // 4
            routes: [
              GoRoute(
                name: 'rw',
                path: 'rw',
                builder: (context, state) => const WebViewScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
    redirect: (state) {
      // 1
      final loggedIn = appStateManager.isLoggedIn;
      // 2
      final loggingIn = state.subloc == '/login';
      // 3
      if (!loggedIn) return loggingIn ? null : '/login';

      // 4
      final isOnboardingComplete = appStateManager.isOnboardingComplete;
      // 5
      final onboarding = state.subloc == '/onboarding';
      // 6
      if (!isOnboardingComplete) {
        return onboarding ? null : '/onboarding';
      }
      // 7
      if (loggingIn || onboarding) return '/${FooderlichTab.explore}';
      // 8
      return null;
    },
  );
}
