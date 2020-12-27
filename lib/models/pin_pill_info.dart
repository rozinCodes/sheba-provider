import 'package:flutter/material.dart';

class PinInformation {
  int techId;
  String techPhoto;
  String techName;
  String expertiseArea;
  double techRating;
  double techLatitude;
  double techLongitude;

  PinInformation(
      {@required this.techId,
      this.techPhoto,
      @required this.techName,
      this.expertiseArea,
      @required this.techRating,
      @required this.techLatitude,
      @required this.techLongitude});
}
