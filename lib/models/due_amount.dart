import 'package:json_annotation/json_annotation.dart';

part 'due_amount.g.dart';

@JsonSerializable()
class DueAmount {
  final int id;
  final String serviceName;
  final double totalAmount;
  final int totalService;

  DueAmount(this.id, this.serviceName, this.totalAmount, this.totalService);

  factory DueAmount.fromJson(Map<String, dynamic> json) => _$DueAmountFromJson(json);

  Map<String, dynamic> toJson() => _$DueAmountToJson(this);
}