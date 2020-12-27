// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOrder _$PlaceOrderFromJson(Map<String, dynamic> json) {
  return PlaceOrder()
    ..serviceItemName = json['serviceItemName'] as String
    ..serviceItemCode = json['serviceItemCode'] as String
    ..technicianUser = json['technicianUser'] as int
    ..technicianUserName = json['technicianUserName'] as String
    ..serviceDetailsDesc = json['serviceDetailsDesc'] as String
    ..orderPlaceTime = json['orderPlaceTime'] as String
    ..techLongitude = (json['techLongitude'] as num)?.toDouble()
    ..techLatitude = (json['techLatitude'] as num)?.toDouble()
    ..technicianGeoLocation = json['technicianGeoLocation'] as String
    ..clientLatitude = (json['clientLatitude'] as num)?.toDouble()
    ..clientLongitude = (json['clientLongitude'] as num)?.toDouble()
    ..clientUser = json['clientUser'] as int
    ..clientUserName = json['clientUserName'] as String
    ..clientPhoneNumber = json['clientPhoneNumber'] as String
    ..clientGeoLocation = json['clientGeoLocation'] as String
    ..paymentAmount = (json['paymentAmount'] as num)?.toDouble()
    ..status = json['status'] as int
    ..serviceCost = (json['serviceCost'] as num)?.toDouble()
    ..learningPeriod = json['learningPeriod'] as String
    ..isLearningOrder = json['isLearningOrder'] as bool
    ..scheduleDate = json['scheduleDate'] as String
    ..isScheduleOrder = json['isScheduleOrder'] as bool
    ..productSerial = json['productSerial'] as String
    ..invoiceNumber = json['invoiceNumber'] as String
    ..warrantyProduct = json['warrantyProduct'] as bool
    ..brandName = json['brandName'] as String;
}

Map<String, dynamic> _$PlaceOrderToJson(PlaceOrder instance) =>
    <String, dynamic>{
      'serviceItemName': instance.serviceItemName,
      'serviceItemCode': instance.serviceItemCode,
      'technicianUser': instance.technicianUser,
      'technicianUserName': instance.technicianUserName,
      'serviceDetailsDesc': instance.serviceDetailsDesc,
      'orderPlaceTime': instance.orderPlaceTime,
      'techLongitude': instance.techLongitude,
      'techLatitude': instance.techLatitude,
      'technicianGeoLocation': instance.technicianGeoLocation,
      'clientLatitude': instance.clientLatitude,
      'clientLongitude': instance.clientLongitude,
      'clientUser': instance.clientUser,
      'clientUserName': instance.clientUserName,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'clientGeoLocation': instance.clientGeoLocation,
      'paymentAmount': instance.paymentAmount,
      'status': instance.status,
      'serviceCost': instance.serviceCost,
      'learningPeriod': instance.learningPeriod,
      'isLearningOrder': instance.isLearningOrder,
      'scheduleDate': instance.scheduleDate,
      'isScheduleOrder': instance.isScheduleOrder,
      'productSerial': instance.productSerial,
      'invoiceNumber': instance.invoiceNumber,
      'warrantyProduct': instance.warrantyProduct,
      'brandName': instance.brandName,
    };
