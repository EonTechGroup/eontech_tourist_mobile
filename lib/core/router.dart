import 'package:eontech_tourist_mobile/features/auth/screens/place_detail_screen.dart';
import 'package:eontech_tourist_mobile/features/profile/screens/profile_screen.dart';
import 'package:eontech_tourist_mobile/features/tourist_explore/screens/explore_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../shared/widgets/main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, _) =>
          OnboardingScreen(onComplete: () => context.go('/login')),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/explore',
          builder: (_, __) => const ExploreScreen(),
          routes: [
            GoRoute(
              path: 'place/:id',
              builder: (context, state) =>
                  PlaceDetailScreen(placeId: state.pathParameters['id']!),
            ),
          ],
        ),
        
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
