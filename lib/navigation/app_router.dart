import 'package:ch07_routes_and_navigation/models/models.dart';
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
      // TODO: ADD Login Route
      // TODO: ADD Onboarding Route
      // TODO: ADD Home Route
    ],
    // TODO: ADD Error Handler
    // TODO: ADD Redirect Handler
  );
}
