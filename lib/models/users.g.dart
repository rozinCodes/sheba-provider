// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) {
  return Users(
    id: json['id'] as int,
    targetEarningPerMonth: json['targetEarningPerMonth'] as String,
    firstName: json['firstName'] as String,
    passwordExpired: json['passwordExpired'] as bool,
    gender: json['gender'] as String,
    fullAddress: json['fullAddress'] as String,
    accountExpired: json['accountExpired'] as bool,
    expertiseArea: json['expertiseArea'] as String,
    isApproved: json['isApproved'] as bool,
    phoneNumber: json['phoneNumber'] as String,
    displayName: json['displayName'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    expertiseKeywords: json['expertiseKeywords'] as String,
    username: json['username'] as String,
    accountLocked: json['accountLocked'] as bool,
    city: json['city'] as String,
    password: json['password'] as String,
    userType: json['userType'] as String,
    birthDate: json['birthDate'] as String,
    lastName: json['lastName'] as String,
    enabled: json['enabled'] as bool,
    email: json['email'] as String,
    imageName: json['imageName'] as String,
    deviceType: json['deviceType'] as String,
    deviceToken: json['deviceToken'] as String,
  );
}

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      'targetEarningPerMonth': instance.targetEarningPerMonth,
      'firstName': instance.firstName,
      'passwordExpired': instance.passwordExpired,
      'gender': instance.gender,
      'fullAddress': instance.fullAddress,
      'accountExpired': instance.accountExpired,
      'expertiseArea': instance.expertiseArea,
      'isApproved': instance.isApproved,
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
      'imageName': instance.imageName,
      'deviceType': instance.deviceType,
      'deviceToken': instance.deviceToken,
    };
