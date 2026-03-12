// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String,
  phone: json['phone'] as String,
  website: json['website'] as String,
  vibes: (json['vibes'] as List<dynamic>).map((e) => e as String).toList(),
  hours: Map<String, String>.from(json['hours'] as Map),
  rating: (json['rating'] as num).toDouble(),
);

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'phone': instance.phone,
  'website': instance.website,
  'vibes': instance.vibes,
  'hours': instance.hours,
  'rating': instance.rating,
};
