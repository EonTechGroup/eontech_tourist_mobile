import '../models/business.dart';
import '../models/offer.dart';
import '../models/user.dart';

class MockData {
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

  static const List<String> vibes = [
    'beach', 'adventure', 'food', 'cultural',
    'family', 'outdoor', 'nightlife', 'wellness',
    'shopping', 'history',
  ];
}