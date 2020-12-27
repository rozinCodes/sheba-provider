import 'package:json_annotation/json_annotation.dart';

part 'order_history.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderHistory {

  int id;
  String serviceItemName;
  String issueImagePath;
  String serviceItemCode;
  double clientLatitude;
  String lastUpdateUser;
  String technicianUserName;
  String clientGeoLocation;
  double techLatitude;
  double clientLongitude;
  bool isRated;
  String serviceItemsId;
  String serviceDetailsDesc;
  int technicianUserId;
  String lastUpdateDateTime;
  String creationDateTime;
  double orderPrice;
  String orderCode;
  int clientUserId;
  double techLongitude;
  double paymentAmount;
  String serviceItems;
  double rating;
  String technicianGeoLocation;
  String creationUser;
  String clientUserName;
  String clientPhoneNumber;
  String orderPlaceTime;
  int status;
  ClientUser clientUser;
  TechnicianUser technicianUser;
  String brandName;
  bool warrantyProduct;
  String invoiceNumber;
  String productSerial;
  bool isAgreed;
  bool servicePartsRequired;
  bool scheduleOrder;
  String scheduleDate;
  bool isLearningOrder;
  String learningPeriod;
  AddCost addCost;

  OrderHistory(
      this.id,
      this.orderPrice,
      this.serviceItemName,
      this.serviceItemsId,
      this.serviceItemCode,
      this.paymentAmount,
      this.serviceDetailsDesc,
      this.clientUserId,
      this.clientUserName,
      this.clientLatitude,
      this.clientLongitude,
      this.clientGeoLocation,
      this.technicianUserId,
      this.technicianUserName,
      this.techLatitude,
      this.techLongitude,
      this.technicianGeoLocation,
      this.isRated,
      this.rating,
      this.status,
      this.orderCode,
      this.orderPlaceTime,
      this.serviceItems,
      this.lastUpdateUser,
      this.issueImagePath,
      this.creationDateTime,
      this.creationUser,
      this.lastUpdateDateTime,
      this.clientUser,
      this.technicianUser);

  factory OrderHistory.fromJson(Map<String, dynamic> json) => _$OrderHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderHistoryToJson(this);
}

@JsonSerializable()
class ClientUser {
  int id;
  double targetEarningPerMonth;
  String firstName;
  bool passwordExpired;
  String gender;
  String fullAddress;
  bool accountExpired;
  String expertiseArea;
  String phoneNumber;
  String displayName;
  double rating;
  String expertiseKeywords;
  String username;
  bool accountLocked;
  String city;
  String password;
  String userType;
  String birthDate;
  String lastName;
  bool enabled;
  String email;
  String deviceType;
  String deviceToken;

  ClientUser(
      this.id,
      this.targetEarningPerMonth,
      this.firstName,
      this.passwordExpired,
      this.gender,
      this.fullAddress,
      this.accountExpired,
      this.expertiseArea,
      this.phoneNumber,
      this.displayName,
      this.rating,
      this.expertiseKeywords,
      this.username,
      this.accountLocked,
      this.city,
      this.password,
      this.userType,
      this.birthDate,
      this.lastName,
      this.enabled,
      this.email,
      this.deviceType,
      this.deviceToken);

  factory ClientUser.fromJson(Map<String, dynamic> json) => _$ClientUserFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUserToJson(this);
}

@JsonSerializable()
class TechnicianUser {
  int id;
  double targetEarningPerMonth;
  String firstName;
  bool passwordExpired;
  String gender;
  String fullAddress;
  bool accountExpired;
  String expertiseArea;
  String phoneNumber;
  String displayName;
  double rating;
  String expertiseKeywords;
  String username;
  bool accountLocked;
  String city;
  String password;
  String userType;
  String birthDate;
  String lastName;
  bool enabled;
  String email;
  String deviceType;
  String deviceToken;


  TechnicianUser(
      this.id,
      this.targetEarningPerMonth,
      this.firstName,
      this.passwordExpired,
      this.gender,
      this.fullAddress,
      this.accountExpired,
      this.expertiseArea,
      this.phoneNumber,
      this.displayName,
      this.rating,
      this.expertiseKeywords,
      this.username,
      this.accountLocked,
      this.city,
      this.password,
      this.userType,
      this.birthDate,
      this.lastName,
      this.enabled,
      this.email,
      this.deviceType,
      this.deviceToken);

  factory TechnicianUser.fromJson(Map<String, dynamic> json) => _$TechnicianUserFromJson(json);

  Map<String, dynamic> toJson() => _$TechnicianUserToJson(this);
}

@JsonSerializable()
class AddCost {
  double partsCost;
  double serviceCost;
  double tadaCost;
  double othersCost;

  AddCost(this.partsCost, this.serviceCost, this.tadaCost, this.othersCost);

  factory AddCost.fromJson(Map<String, dynamic> json) => _$AddCostFromJson(json);

  Map<String, dynamic> toJson() => _$AddCostToJson(this);
}
