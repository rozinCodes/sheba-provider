// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceItem _$ServiceItemFromJson(Map<String, dynamic> json) {
  return ServiceItem(
    id: json['id'] as int,
    active: json['active'] as bool,
    lastUpdateUser: json['lastUpdateUser'] as String,
    minPrice: (json['minPrice'] as num)?.toDouble(),
    iconName: json['iconName'] as String,
    techRatingPrice: (json['techRatingPrice'] as num)?.toDouble(),
    iconImgPath: json['iconImgPath'] as String,
    itemName: json['itemName'] as String,
    itemCode: json['itemCode'] as String,
    sequence: json['sequence'] as int,
    comChargePct: (json['comChargePct'] as num)?.toDouble(),
    regularPrice: (json['regularPrice'] as num)?.toDouble(),
    creationDateTime: json['creationDateTime'] as String,
    itemDescription: json['itemDescription'] as String,
    creationUser: json['creationUser'] as String,
    lastUpdateDateTime: json['lastUpdateDateTime'] as String,
  );
}

Map<String, dynamic> _$ServiceItemToJson(ServiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'sequence': instance.sequence,
      'iconName': instance.iconName,
      'minPrice': instance.minPrice,
      'techRatingPrice': instance.techRatingPrice,
      'iconImgPath': instance.iconImgPath,
      'itemName': instance.itemName,
      'itemCode': instance.itemCode,
      'comChargePct': instance.comChargePct,
      'regularPrice': instance.regularPrice,
      'creationDateTime': instance.creationDateTime,
      'itemDescription': instance.itemDescription,
      'creationUser': instance.creationUser,
      'lastUpdateUser': instance.lastUpdateUser,
      'lastUpdateDateTime': instance.lastUpdateDateTime,
    };
