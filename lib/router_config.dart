import 'package:go_router/go_router.dart';
import 'package:movies_task/screens/account_screen.dart';
import 'package:movies_task/screens/fav_screen.dart';
import 'package:movies_task/screens/home_screen.dart';
import 'package:movies_task/screens/list_screen.dart';
import 'package:movies_task/screens/login_screen.dart';
import 'package:movies_task/screens/movie_details_screen.dart';

GoRouter routerConfig = GoRouter(
  routes: _routes,
  initialLocation: '/login_screen',
);

List<RouteBase> _routes = [
  GoRoute(path: '/login_screen', builder: (context, state) => LoginScreen()),
  StatefulShellRoute.indexedStack(
    builder:
        (context, state, navigationShell) =>
            HomeScreen(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/list',
            builder: (context, state) => ListScreen(),
            routes: [
              GoRoute(
                path: '/movie:movieId',
                builder: (context, state) => MovieDetailsScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(path: '/fav', builder: (context, state) => FavScreen()),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/account',
            builder: (context, state) => AccountScreen(),
          ),
        ],
      ),
    ],
  ),
];
