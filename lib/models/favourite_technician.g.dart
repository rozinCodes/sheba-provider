// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_technician.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteTechnician _$FavouriteTechnicianFromJson(Map<String, dynamic> json) {
  return FavouriteTechnician(
    json['id'] as int,
    json['techId'] as int,
    json['name'] as String,
    json['favorite'] as bool,
    json['expertiseArea'] as String,
  );
}

Map<String, dynamic> _$FavouriteTechnicianToJson(
        FavouriteTechnician instance) =>
    <String, dynamic>{
      'id': instance.id,
      'techId': instance.techId,
      'name': instance.name,
      'favorite': instance.favorite,
      'expertiseArea': instance.expertiseArea,
    };
