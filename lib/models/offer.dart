class Offer {
  final int id;
  final String promoCode;
  final double discountAmount;
  final String expiryDate;
  final int leftPromo;
  final String title;
  final String conditions;
  final bool isExpired;
  final String type;
  final String creationDateTime;
  bool isSelected;

  Offer(
      this.id,
      this.promoCode,
      this.discountAmount,
      this.expiryDate,
      this.leftPromo,
      this.title,
      this.conditions,
      this.isExpired,
      this.type,
      this.creationDateTime,
      this.isSelected);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['id'] as int,
      json['promoCode'] as String,
      (json['discountAmount'] as num)?.toDouble(),
      json['expiryDate'] as String,
      json['leftPromo'] as int,
      json['title'] as String,
      json['conditions'] as String,
      json['isExpired'] as bool,
      json['type'] as String,
      json['creationDateTime'] as String,
      json['isSelected'] as bool ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'promoCode': promoCode,
    'discountAmount': discountAmount,
    'expiryDate': expiryDate,
    'leftPromo': leftPromo,
    'title': title,
    'conditions': conditions,
    'isExpired': isExpired,
    'type': type,
    'creationDateTime': creationDateTime,
    'isSelected': isSelected,
  };

  /*bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }*/
}
