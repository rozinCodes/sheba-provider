// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DueAmount _$DueAmountFromJson(Map<String, dynamic> json) {
  return DueAmount(
    json['id'] as int,
    json['serviceName'] as String,
    (json['totalAmount'] as num)?.toDouble(),
    json['totalService'] as int,
  );
}

Map<String, dynamic> _$DueAmountToJson(DueAmount instance) => <String, dynamic>{
      'id': instance.id,
      'serviceName': instance.serviceName,
      'totalAmount': instance.totalAmount,
      'totalService': instance.totalService,
    };
