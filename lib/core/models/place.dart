class Place {
  final String id;
  final String name;
  final String description;
  final String category;
  final String district;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> imagePaths;
  final String entryFee;
  final String bestTime;
  final List<String> tags;
  final bool isFeatured;
  final String contactNumber;
  final String? website;
  final String? openingHours;
  final Map<String, String> hours;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.imagePaths,
    required this.entryFee,
    required this.bestTime,
    required this.tags,
    required this.hours,
    this.isFeatured = false,
    this.contactNumber = '',
    this.website,
    this.openingHours,
  });

  // ── Helpers ────────────────────────────────────────────

  /// Returns true if entryFee is "Free"
  bool get isFree => entryFee.toLowerCase() == 'free';

  /// Short district + category label e.g. "Galle · Heritage"
  String get locationLabel =>
      '$district · ${category[0].toUpperCase()}${category.substring(1)}';

  /// First image path or empty string
  String get primaryImage =>
      imagePaths.isNotEmpty ? imagePaths.first : '';

  /// copyWith for local state updates
  Place copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? district,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    List<String>? imagePaths,
    String? entryFee,
    String? bestTime,
    List<String>? tags,
    Map<String, String>? hours,
    bool? isFeatured,
    String? contactNumber,
    String? website,
    String? openingHours,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imagePaths: imagePaths ?? this.imagePaths,
      entryFee: entryFee ?? this.entryFee,
      bestTime: bestTime ?? this.bestTime,
      tags: tags ?? this.tags,
      hours: hours ?? this.hours,
      isFeatured: isFeatured ?? this.isFeatured,
      contactNumber: contactNumber ?? this.contactNumber,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Place && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Place(id: $id, name: $name, district: $district)';
}