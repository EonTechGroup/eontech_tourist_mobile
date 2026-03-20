import 'package:eontech_tourist_mobile/features/owner/owner_dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/tourist_explore/screens/explore_screen.dart';
import '../features/places/screens/place_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/itinerary/screens/itinerary_screen.dart';
import '../features/emergency/screens/emergency_screen.dart';
import '../features/owner/screens/analytics_screen.dart';
import '../features/owner/screens/reviews_screen.dart';
import '../features/map/screens/location_picker_screen.dart';
import '../shared/widgets/main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    // ── Auth (no nav bar) ──────────────────────────────────────────────────
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
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    // ── Full-screen push routes (no nav bar) ───────────────────────────────
    GoRoute(
      path: '/analytics',
      builder: (context, state) {
        final name =
            (state.extra as Map<String, dynamic>?)?['name'] as String? ??
                'My Business';
        return AnalyticsScreen(businessName: name);
      },
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) {
        final name =
            (state.extra as Map<String, dynamic>?)?['name'] as String? ??
                'My Business';
        return ReviewsScreen(businessName: name);
      },
    ),
    GoRoute(
      path: '/location-picker',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final lat = extra?['lat'] as double?;
        final lng = extra?['lng'] as double?;
        return LocationPickerScreen(
          initialLocation:
              (lat != null && lng != null) ? LatLng(lat, lng) : null,
        );
      },
    ),

    // ── Shell (with nav bar) ───────────────────────────────────────────────
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
          path: '/itinerary',
          builder: (_, __) => const ItineraryScreen(),
        ),
        GoRoute(
          path: '/emergency',
          builder: (_, __) => const EmergencyScreen(),
        ),
        GoRoute(
          path: '/owner',
          builder: (_, __) => const OwnerDashboardScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);