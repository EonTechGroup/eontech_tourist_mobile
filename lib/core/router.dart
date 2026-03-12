import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/tourist_explore/screens/explore_screen.dart';
import '../features/tourist_explore/screens/business_detail_screen.dart';
import '../features/tourist_offers/offers_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/owner_dashboard/dashboard_screen.dart';
import '../shared/widgets/main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(onComplete: () {  },),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Main shell with bottom nav
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
          routes: [
            GoRoute(
              path: 'business/:id',
              builder: (context, state) => BusinessDetailScreen(
                businessId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/offers',
          builder: (context, state) => const OffersScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
  ],
);