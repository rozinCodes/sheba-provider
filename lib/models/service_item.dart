import 'package:json_annotation/json_annotation.dart';

part 'service_item.g.dart';

@JsonSerializable()
class ServiceItem {
  int id;
  bool active;
  int sequence;
  String iconName;
  double minPrice;
  double techRatingPrice;
  String iconImgPath;
  String itemName;
  String itemCode;
  double comChargePct;
  double regularPrice;
  String creationDateTime;
  String itemDescription;
  String creationUser;
  String lastUpdateUser;
  String lastUpdateDateTime;

  ServiceItem({this.id, this.active, this.lastUpdateUser, this.minPrice, this.iconName, this.techRatingPrice, this.iconImgPath, this.itemName, this.itemCode, this.sequence, this.comChargePct, this.regularPrice, this.creationDateTime, this.itemDescription, this.creationUser, this.lastUpdateDateTime});

  factory ServiceItem.fromJson(Map<String, dynamic> json) => _$ServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemToJson(this);
}

