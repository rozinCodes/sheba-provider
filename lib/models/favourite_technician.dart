import 'package:json_annotation/json_annotation.dart';

part 'favourite_technician.g.dart';

@JsonSerializable()
class FavouriteTechnician {
  final int id;
  final int techId;
  final String name;
  final bool favorite;
  final String expertiseArea;

  FavouriteTechnician(this.id, this.techId, this.name, this.favorite, this.expertiseArea);

  factory FavouriteTechnician.fromJson(Map<String, dynamic> json) => _$FavouriteTechnicianFromJson(json);

  Map<String, dynamic> toJson() => _$FavouriteTechnicianToJson(this);
}
