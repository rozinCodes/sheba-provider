// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    id: json['id'] as int,
    userId: json['userId'] as int,
    userType: json['userType'] as String,
    status: json['status'] as int,
    orderCode: json['orderCode'] as String,
    organization: json['organization'] as String,
    organizationId: json['organizationId'] as int,
    isPromotional: json['isPromotional'] as bool,
    message: json['message'] as String,
    timestamp: json['timestamp'] as String,
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'userType': instance.userType,
      'orderCode': instance.orderCode,
      'organizationId': instance.organizationId,
      'organization': instance.organization,
      'isPromotional': instance.isPromotional,
      'message': instance.message,
      'timestamp': instance.timestamp,
    };
