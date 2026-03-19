class ItineraryItem {
  final String placeId;
  final String placeName;
  final String? note;
  final int dayNumber;
  final String? time;

  const ItineraryItem({
    required this.placeId,
    required this.placeName,
    this.note,
    required this.dayNumber,
    this.time,
  });

  ItineraryItem copyWith({
    String? placeId,
    String? placeName,
    String? note,
    int? dayNumber,
    String? time,
  }) {
    return ItineraryItem(
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      note: note ?? this.note,
      dayNumber: dayNumber ?? this.dayNumber,
      time: time ?? this.time,
    );
  }
}

class Itinerary {
  final String id;
  final String title;
  final List<ItineraryItem> items;
  final DateTime createdAt;

  const Itinerary({
    required this.id,
    required this.title,
    required this.items,
    required this.createdAt,
  });
}