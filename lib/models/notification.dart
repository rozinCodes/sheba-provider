import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  int id;
  int userId;
  int status;
  String userType;
  String orderCode;
  int organizationId;
  String organization;
  bool isPromotional;
  String message;
  String timestamp;

  Notification({this.id, this.userId, this.userType, this.status, this.orderCode, this.organization, this.organizationId, this.isPromotional, this.message, this.timestamp});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

