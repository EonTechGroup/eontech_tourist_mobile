import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  final String id;
  final String businessId;
  final String businessName;
  final String title;
  final String description;
  final double discountPercent;
  final DateTime expiresAt;
  final double radiusKm;

  const Offer({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.expiresAt,
    required this.radiusKm,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}