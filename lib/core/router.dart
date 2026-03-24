import 'package:eontech_tourist_mobile/features/owner/owner_dashboard_screen.dart';
import 'package:eontech_tourist_mobile/features/tourist_explore/screens/business_detail_screen.dart';
import 'package:eontech_tourist_mobile/features/tourist_explore/screens/offer_detail_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

// Auth
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';

// Tourist
import '../features/tourist_explore/screens/explore_screen.dart';
import '../features/places/screens/place_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/itinerary/screens/itinerary_screen.dart';
import '../features/emergency/screens/emergency_screen.dart';
import '../features/offers/screens/offers_screen.dart';

// Owner
import '../features/owner/screens/analytics_screen.dart';
import '../features/owner/screens/reviews_screen.dart';

// Map
import '../features/map/screens/location_picker_screen.dart';

// Shared
import '../shared/widgets/main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',

  routes: [
    // ───────────────── AUTH (NO NAV BAR) ─────────────────
    GoRoute(
      path: '/onboarding',
      builder: (context, state) =>
          OnboardingScreen(onComplete: () => context.go('/login')),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // ───────────────── FULL SCREEN (NO NAV BAR) ──────────
    GoRoute(
      path: '/analytics',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final name = extra?['name'] ?? 'My Business';

        return AnalyticsScreen(businessName: name);
      },
    ),

    GoRoute(
      path: '/reviews',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final name = extra?['name'] ?? 'My Business';

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

    // ───────────────── MAIN SHELL (WITH NAV BAR) ─────────
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },

      routes: [
        // ── Explore ──
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),

          routes: [
            GoRoute(
              path: 'place/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PlaceDetailScreen(placeId: id);
              },
            ),
          ],
        ),

        // ── Itinerary ──
        GoRoute(
          path: '/itinerary',
          builder: (context, state) => const ItineraryScreen(),
        ),

        // ── Emergency ──
        GoRoute(
          path: '/emergency',
          builder: (context, state) => const EmergencyScreen(),
        ),

        // ── Owner Dashboard ──
        GoRoute(
          path: '/owner',
          builder: (context, state) => const OwnerDashboardScreen(),
        ),

        // ── Offers ──
        GoRoute(
          path: '/offers',
          builder: (context, state) => const OffersScreen(),

          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final offerId = state.pathParameters['id']!;
                return OfferDetailScreen(offerId: offerId);
              },
            ),
          ],
        ),

        // ── Profile ──
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        // ── Business Detail ──
        GoRoute(
          path: '/business/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BusinessDetailScreen(businessId: id);
          },
        ),
      ],
    ),
  ],
);