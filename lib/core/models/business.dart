import 'package:json_annotation/json_annotation.dart';

part 'business.g.dart';

@JsonSerializable()
class Business {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String website;
  final List<String> vibes;
  final Map<String, String> hours;
  final double rating;

  const Business({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.website,
    required this.vibes,
    required this.hours,
    required this.rating,
  });

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}