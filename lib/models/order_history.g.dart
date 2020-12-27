// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHistory _$OrderHistoryFromJson(Map<String, dynamic> json) {
  return OrderHistory(
    json['id'] as int,
    (json['orderPrice'] as num)?.toDouble(),
    json['serviceItemName'] as String,
    json['serviceItemsId'] as String,
    json['serviceItemCode'] as String,
    (json['paymentAmount'] as num)?.toDouble(),
    json['serviceDetailsDesc'] as String,
    json['clientUserId'] as int,
    json['clientUserName'] as String,
    (json['clientLatitude'] as num)?.toDouble(),
    (json['clientLongitude'] as num)?.toDouble(),
    json['clientGeoLocation'] as String,
    json['technicianUserId'] as int,
    json['technicianUserName'] as String,
    (json['techLatitude'] as num)?.toDouble(),
    (json['techLongitude'] as num)?.toDouble(),
    json['technicianGeoLocation'] as String,
    json['isRated'] as bool,
    (json['rating'] as num)?.toDouble(),
    json['status'] as int,
    json['orderCode'] as String,
    json['orderPlaceTime'] as String,
    json['serviceItems'] as String,
    json['lastUpdateUser'] as String,
    json['issueImagePath'] as String,
    json['creationDateTime'] as String,
    json['creationUser'] as String,
    json['lastUpdateDateTime'] as String,
    json['clientUser'] == null
        ? null
        : ClientUser.fromJson(json['clientUser'] as Map<String, dynamic>),
    json['technicianUser'] == null
        ? null
        : TechnicianUser.fromJson(
            json['technicianUser'] as Map<String, dynamic>),
  )
    ..clientPhoneNumber = json['clientPhoneNumber'] as String
    ..brandName = json['brandName'] as String
    ..warrantyProduct = json['warrantyProduct'] as bool
    ..invoiceNumber = json['invoiceNumber'] as String
    ..productSerial = json['productSerial'] as String
    ..isAgreed = json['isAgreed'] as bool
    ..servicePartsRequired = json['servicePartsRequired'] as bool
    ..scheduleOrder = json['scheduleOrder'] as bool
    ..scheduleDate = json['scheduleDate'] as String
    ..isLearningOrder = json['isLearningOrder'] as bool
    ..learningPeriod = json['learningPeriod'] as String
    ..addCost = json['addCost'] == null
        ? null
        : AddCost.fromJson(json['addCost'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderHistoryToJson(OrderHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceItemName': instance.serviceItemName,
      'issueImagePath': instance.issueImagePath,
      'serviceItemCode': instance.serviceItemCode,
      'clientLatitude': instance.clientLatitude,
      'lastUpdateUser': instance.lastUpdateUser,
      'technicianUserName': instance.technicianUserName,
      'clientGeoLocation': instance.clientGeoLocation,
      'techLatitude': instance.techLatitude,
      'clientLongitude': instance.clientLongitude,
      'isRated': instance.isRated,
      'serviceItemsId': instance.serviceItemsId,
      'serviceDetailsDesc': instance.serviceDetailsDesc,
      'technicianUserId': instance.technicianUserId,
      'lastUpdateDateTime': instance.lastUpdateDateTime,
      'creationDateTime': instance.creationDateTime,
      'orderPrice': instance.orderPrice,
      'orderCode': instance.orderCode,
      'clientUserId': instance.clientUserId,
      'techLongitude': instance.techLongitude,
      'paymentAmount': instance.paymentAmount,
      'serviceItems': instance.serviceItems,
      'rating': instance.rating,
      'technicianGeoLocation': instance.technicianGeoLocation,
      'creationUser': instance.creationUser,
      'clientUserName': instance.clientUserName,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'orderPlaceTime': instance.orderPlaceTime,
      'status': instance.status,
      'clientUser': instance.clientUser?.toJson(),
      'technicianUser': instance.technicianUser?.toJson(),
      'brandName': instance.brandName,
      'warrantyProduct': instance.warrantyProduct,
      'invoiceNumber': instance.invoiceNumber,
      'productSerial': instance.productSerial,
      'isAgreed': instance.isAgreed,
      'servicePartsRequired': instance.servicePartsRequired,
      'scheduleOrder': instance.scheduleOrder,
      'scheduleDate': instance.scheduleDate,
      'isLearningOrder': instance.isLearningOrder,
      'learningPeriod': instance.learningPeriod,
      'addCost': instance.addCost?.toJson(),
    };

ClientUser _$ClientUserFromJson(Map<String, dynamic> json) {
  return ClientUser(
    json['id'] as int,
    (json['targetEarningPerMonth'] as num)?.toDouble(),
    json['firstName'] as String,
    json['passwordExpired'] as bool,
    json['gender'] as String,
    json['fullAddress'] as String,
    json['accountExpired'] as bool,
    json['expertiseArea'] as String,
    json['phoneNumber'] as String,
    json['displayName'] as String,
    (json['rating'] as num)?.toDouble(),
    json['expertiseKeywords'] as String,
    json['username'] as String,
    json['accountLocked'] as bool,
    json['city'] as String,
    json['password'] as String,
    json['userType'] as String,
    json['birthDate'] as String,
    json['lastName'] as String,
    json['enabled'] as bool,
    json['email'] as String,
    json['deviceType'] as String,
    json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$ClientUserToJson(ClientUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetEarningPerMonth': instance.targetEarningPerMonth,
      'firstName': instance.firstName,
      'passwordExpired': instance.passwordExpired,
      'gender': instance.gender,
      'fullAddress': instance.fullAddress,
      'accountExpired': instance.accountExpired,
      'expertiseArea': instance.expertiseArea,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'rating': instance.rating,
      'expertiseKeywords': instance.expertiseKeywords,
      'username': instance.username,
      'accountLocked': instance.accountLocked,
      'city': instance.city,
      'password': instance.password,
      'userType': instance.userType,
      'birthDate': instance.birthDate,
      'lastName': instance.lastName,
      'enabled': instance.enabled,
      'email': instance.email,
      'deviceType': instance.deviceType,
      'deviceToken': instance.deviceToken,
    };

TechnicianUser _$TechnicianUserFromJson(Map<String, dynamic> json) {
  return TechnicianUser(
    json['id'] as int,
    (json['targetEarningPerMonth'] as num)?.toDouble(),
    json['firstName'] as String,
    json['passwordExpired'] as bool,
    json['gender'] as String,
    json['fullAddress'] as String,
    json['accountExpired'] as bool,
    json['expertiseArea'] as String,
    json['phoneNumber'] as String,
    json['displayName'] as String,
    (json['rating'] as num)?.toDouble(),
    json['expertiseKeywords'] as String,
    json['username'] as String,
    json['accountLocked'] as bool,
    json['city'] as String,
    json['password'] as String,
    json['userType'] as String,
    json['birthDate'] as String,
    json['lastName'] as String,
    json['enabled'] as bool,
    json['email'] as String,
    json['deviceType'] as String,
    json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$TechnicianUserToJson(TechnicianUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetEarningPerMonth': instance.targetEarningPerMonth,
      'firstName': instance.firstName,
      'passwordExpired': instance.passwordExpired,
      'gender': instance.gender,
      'fullAddress': instance.fullAddress,
      'accountExpired': instance.accountExpired,
      'expertiseArea': instance.expertiseArea,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'rating': instance.rating,
      'expertiseKeywords': instance.expertiseKeywords,
      'username': instance.username,
      'accountLocked': instance.accountLocked,
      'city': instance.city,
      'password': instance.password,
      'userType': instance.userType,
      'birthDate': instance.birthDate,
      'lastName': instance.lastName,
      'enabled': instance.enabled,
      'email': instance.email,
      'deviceType': instance.deviceType,
      'deviceToken': instance.deviceToken,
    };

AddCost _$AddCostFromJson(Map<String, dynamic> json) {
  return AddCost(
    (json['partsCost'] as num)?.toDouble(),
    (json['serviceCost'] as num)?.toDouble(),
    (json['tadaCost'] as num)?.toDouble(),
    (json['othersCost'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$AddCostToJson(AddCost instance) => <String, dynamic>{
      'partsCost': instance.partsCost,
      'serviceCost': instance.serviceCost,
      'tadaCost': instance.tadaCost,
      'othersCost': instance.othersCost,
    };
