import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'users.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Users {
  final int id;
  final String targetEarningPerMonth;
  final String firstName;
  final bool passwordExpired;
  final String gender;
  final String fullAddress;
  final bool accountExpired;
  final String expertiseArea;
  final bool isApproved;
  final String phoneNumber;
  final String displayName;
  final double rating;
  final String expertiseKeywords;
  final String username;
  final bool accountLocked;
  final String city;
  final String password;
  final String userType;
  final String birthDate;
  final String lastName;
  final bool enabled;
  final String email;
  final String imageName;
  final String deviceType;
  final String deviceToken;

  Users({this.id,
      this.targetEarningPerMonth,
      this.firstName,
      this.passwordExpired,
      this.gender,
      this.fullAddress,
      this.accountExpired,
      this.expertiseArea,
      this.isApproved,
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
      this.imageName,
      this.deviceType,
      this.deviceToken});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
