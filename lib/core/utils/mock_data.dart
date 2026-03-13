import '../models/business.dart';
import '../models/offer.dart';
import '../models/user.dart';
import '../models/place.dart';

class MockData {
  // ── Businesses ─────────────────────────────────────────
  static final List<Business> businesses = [
    const Business(
      id: 'b1',
      name: 'The Surf Shack',
      description: 'Best surf gear and lessons in town.',
      imageUrl: 'https://picsum.photos/seed/surf/800/400',
      latitude: 7.2094,
      longitude: 79.8359,
      address: '12 Beach Road, Negombo',
      phone: '+94771234567',
      website: 'https://surfshack.lk',
      vibes: ['beach', 'adventure', 'outdoor'],
      hours: {
        'Mon-Fri': '8:00 AM - 6:00 PM',
        'Sat-Sun': '7:00 AM - 7:00 PM',
      },
      rating: 4.7,
    ),
    const Business(
      id: 'b2',
      name: 'Spice Garden Restaurant',
      description: 'Authentic Sri Lankan cuisine.',
      imageUrl: 'https://picsum.photos/seed/spice/800/400',
      latitude: 7.2110,
      longitude: 79.8370,
      address: '45 Main Street, Negombo',
      phone: '+94779876543',
      website: 'https://spicegarden.lk',
      vibes: ['food', 'cultural', 'family'],
      hours: {
        'Daily': '11:00 AM - 10:00 PM',
      },
      rating: 4.5,
    ),
  ];

  // ── Offers ─────────────────────────────────────────────
  static final List<Offer> offers = [
    Offer(
      id: 'o1',
      businessId: 'b1',
      businessName: 'The Surf Shack',
      title: '30% Off Surf Lessons!',
      description: 'Flash deal — book now before it expires.',
      discountPercent: 30,
      expiresAt: DateTime.now().add(const Duration(hours: 2)),
      radiusKm: 3.0,
    ),
    Offer(
      id: 'o2',
      businessId: 'b2',
      businessName: 'Spice Garden Restaurant',
      title: 'Free Dessert with Any Main',
      description: 'Limited time offer for nearby tourists.',
      discountPercent: 15,
      expiresAt: DateTime.now().add(const Duration(minutes: 45)),
      radiusKm: 1.5,
    ),
  ];

  // ── Users ──────────────────────────────────────────────
  static const AppUser tourist = AppUser(
    id: 'u1',
    email: 'tourist@test.com',
    name: 'Traveller Sam',
    role: UserRole.tourist,
  );

  static const AppUser owner = AppUser(
    id: 'u2',
    email: 'owner@test.com',
    name: 'Vinura D.',
    role: UserRole.businessOwner,
  );

  // ── Vibes ──────────────────────────────────────────────
  static const List<String> vibes = [
    'beach', 'adventure', 'food', 'cultural',
    'family', 'outdoor', 'nightlife', 'wellness',
    'shopping', 'history',
  ];

  // ── Places ─────────────────────────────────────────────
  static const List<Place> places = [
    Place(
      id: 'galle-fort',
      name: 'Galle Fort',
      description:
          'A UNESCO World Heritage Site and the best-preserved sea fort '
          'in South Asia, built by the Portuguese in 1588 and later '
          'fortified by the Dutch.',
      category: 'heritage',
      district: 'Galle',
      latitude: 6.0267,
      longitude: 80.2170,
      rating: 4.8,
      reviewCount: 3241,
      imagePaths: ['assets/images/1.jpg'],
      entryFee: 'Free',
      bestTime: 'Early Morning / Sunset',
      tags: ['UNESCO', 'Heritage', 'Photography', 'History', 'Walking'],
      hours: {
        'Daily': 'Open 24 hours',
        'Museum': '9:00 AM - 6:00 PM',
      },
      isFeatured: true,
      contactNumber: '+94912234567',
      website: 'https://gallefort.gov.lk',
    ),
    Place(
      id: 'mirissa-beach',
      name: 'Mirissa Beach',
      description:
          'A stunning crescent-shaped beach famous for whale watching, '
          'surfing, and a laid-back tropical vibe.',
      category: 'beach',
      district: 'Matara',
      latitude: 5.9483,
      longitude: 80.4716,
      rating: 4.6,
      reviewCount: 2108,
      imagePaths: ['assets/images/2.jpg'],
      entryFee: 'Free',
      bestTime: '6AM - 6PM',
      tags: ['Beach', 'Whale Watching', 'Surfing', 'Snorkeling', 'Sunset'],
      hours: {
        'Daily': 'Sunrise to Sunset',
        'Whale Watching Tours': '6:00 AM - 11:00 AM',
      },
      isFeatured: true,
      website: 'https://visitmirissa.com',
    ),
    Place(
      id: 'yala-national-park',
      name: 'Yala National Park',
      description:
          'Sri Lanka\'s most visited wildlife reserve, home to the '
          'highest density of leopards in the world.',
      category: 'wildlife',
      district: 'Hambantota',
      latitude: 6.3728,
      longitude: 81.5216,
      rating: 4.9,
      reviewCount: 4502,
      imagePaths: ['assets/images/3.jpg'],
      entryFee: 'USD 15',
      bestTime: '6AM - 10AM / 3PM - 6PM',
      tags: ['Safari', 'Leopard', 'Elephant', 'Birdwatching', 'Nature'],
      hours: {
        'Park Gates': '6:00 AM - 6:00 PM',
        'Closed': 'Every Tuesday (Half Day)',
      },
      isFeatured: true,
      contactNumber: '+94472220026',
      website: 'https://yalasrilanka.lk',
    ),
    Place(
      id: 'unawatuna-beach',
      name: 'Unawatuna Beach',
      description:
          'One of Sri Lanka\'s most popular beaches with calm turquoise '
          'waters, vibrant coral reefs, and a lively beach restaurant scene.',
      category: 'beach',
      district: 'Galle',
      latitude: 6.0090,
      longitude: 80.2497,
      rating: 4.5,
      reviewCount: 1876,
      imagePaths: ['assets/images/1.jpg'],
      entryFee: 'Free',
      bestTime: '7AM - 7PM',
      tags: ['Beach', 'Snorkeling', 'Diving', 'Relaxation', 'Nightlife'],
      hours: {
        'Daily': 'Sunrise to Sunset',
      },
      isFeatured: false,
    ),
    Place(
      id: 'kataragama-temple',
      name: 'Kataragama Temple',
      description:
          'A sacred pilgrimage site venerated by Buddhists, Hindus, '
          'and Muslims alike.',
      category: 'temple',
      district: 'Hambantota',
      latitude: 6.4145,
      longitude: 81.3352,
      rating: 4.7,
      reviewCount: 987,
      imagePaths: ['assets/images/2.jpg'],
      entryFee: 'Free',
      bestTime: '5AM - 8PM',
      tags: ['Temple', 'Pilgrimage', 'Culture', 'Multi-faith', 'Sacred'],
      hours: {
        'Daily': '5:00 AM - 8:00 PM',
        'Puja Times': '6:30 AM, 11:00 AM, 7:00 PM',
      },
      isFeatured: false,
      contactNumber: '+94472235271',
    ),
    Place(
      id: 'tangalle-beach',
      name: 'Tangalle Beach',
      description:
          'A serene and less-crowded beach town with beautiful lagoons '
          'and turtle nesting sites.',
      category: 'beach',
      district: 'Hambantota',
      latitude: 6.0244,
      longitude: 80.7975,
      rating: 4.4,
      reviewCount: 765,
      imagePaths: ['assets/images/3.jpg'],
      entryFee: 'Free',
      bestTime: 'Sunrise to Sunset',
      tags: ['Beach', 'Turtles', 'Quiet', 'Lagoon', 'Nature'],
      hours: {
        'Daily': 'Open 24 hours',
      },
      isFeatured: false,
    ),
    Place(
      id: 'sinharaja-forest',
      name: 'Sinharaja Forest Reserve',
      description:
          'A UNESCO World Heritage rainforest and biodiversity hotspot, '
          'home to over 50% of Sri Lanka\'s endemic species.',
      category: 'adventure',
      district: 'Galle',
      latitude: 6.4014,
      longitude: 80.4997,
      rating: 4.7,
      reviewCount: 632,
      imagePaths: ['assets/images/1.jpg'],
      entryFee: 'LKR 730',
      bestTime: 'August - September / January - April',
      tags: ['Rainforest', 'Trekking', 'Birdwatching', 'UNESCO', 'Nature'],
      hours: {
        'Daily': '8:00 AM - 4:00 PM',
      },
      isFeatured: false,
      contactNumber: '+94412223565',
    ),
  ];

  // ── Categories ─────────────────────────────────────────
  static const List<Map<String, dynamic>> categories = [
    {'id': 'all',       'label': 'All',       'icon': '🌍'},
    {'id': 'beach',     'label': 'Beaches',   'icon': '🏖️'},
    {'id': 'heritage',  'label': 'Heritage',  'icon': '🏛️'},
    {'id': 'wildlife',  'label': 'Wildlife',  'icon': '🐆'},
    {'id': 'temple',    'label': 'Temples',   'icon': '🛕'},
    {'id': 'food',      'label': 'Food',      'icon': '🍛'},
    {'id': 'adventure', 'label': 'Adventure', 'icon': '🧗'},
  ];

  // ── Districts ──────────────────────────────────────────
  static const List<String> districts = [
    'All', 'Galle', 'Matara', 'Hambantota',
  ];

  // ── Emergency Contacts ─────────────────────────────────
  static const List<Map<String, String>> emergencyContacts = [
    {'title': 'Police Emergency',     'number': '119'},
    {'title': 'Ambulance',            'number': '1990'},
    {'title': 'Fire & Rescue',        'number': '110'},
    {'title': 'Tourist Police Galle', 'number': '+94912222228'},
    {'title': 'Tourist Helpline',     'number': '1912'},
    {'title': 'Hospital Galle',       'number': '+94912222261'},
    {'title': 'Hospital Matara',      'number': '+94412222261'},
    {'title': 'Coast Guard',          'number': '+94112421051'},
  ];
}