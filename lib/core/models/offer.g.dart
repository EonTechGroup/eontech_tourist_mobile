// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  businessName: json['businessName'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  discountPercent: (json['discountPercent'] as num).toDouble(),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  radiusKm: (json['radiusKm'] as num).toDouble(),
);

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'businessName': instance.businessName,
  'title': instance.title,
  'description': instance.description,
  'discountPercent': instance.discountPercent,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'radiusKm': instance.radiusKm,
};
