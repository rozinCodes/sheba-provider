import 'package:json_annotation/json_annotation.dart';

part 'place_order.g.dart';

@JsonSerializable()
class PlaceOrder {
  String _serviceItemName;
  String _serviceItemCode;
  int _clientUser;
  String _clientUserName;
  String _clientPhoneNumber;
  String _clientGeoLocation;
  double _clientLatitude;
  double _clientLongitude;
  int _technicianUser;
  String _technicianUserName;
  String _technicianGeoLocation;
  double _techLatitude;
  double _techLongitude;
  String _orderPlaceTime;
  String _serviceDetailsDesc;
  double _paymentAmount;
  int _status = 0;
  String _brandName;
  bool _warrantyProduct;
  String _invoiceNumber;
  String _productSerial;
  //bool _isAgreed;
  //bool _servicePartsRequired;
  bool _isScheduleOrder;
  String _scheduleDate;
  bool _isLearningOrder;
  String _learningPeriod;
  double _serviceCost;

  PlaceOrder(); // default constructor

  factory PlaceOrder.fromJson(Map<String, dynamic> json) => _$PlaceOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderToJson(this);

  String get serviceItemName => _serviceItemName;

  set serviceItemName(String value) {
    _serviceItemName = value;
  }

  String get serviceItemCode => _serviceItemCode;

  set serviceItemCode(String value) {
    _serviceItemCode = value;
  }

  int get technicianUser => _technicianUser;

  set technicianUser(int value) {
    _technicianUser = value;
  }

  String get technicianUserName => _technicianUserName;

  set technicianUserName(String value) {
    _technicianUserName = value;
  }

  String get serviceDetailsDesc => _serviceDetailsDesc;

  set serviceDetailsDesc(String value) {
    _serviceDetailsDesc = value;
  }

  String get orderPlaceTime => _orderPlaceTime;

  set orderPlaceTime(String value) {
    _orderPlaceTime = value;
  }

  double get techLongitude => _techLongitude;

  set techLongitude(double value) {
    _techLongitude = value;
  }

  double get techLatitude => _techLatitude;

  set techLatitude(double value) {
    _techLatitude = value;
  }

  String get technicianGeoLocation => _technicianGeoLocation;

  set technicianGeoLocation(String value) {
    _technicianGeoLocation = value;
  }

  double get clientLatitude => _clientLatitude;

  set clientLatitude(double value) {
    _clientLatitude = value;
  }

  double get clientLongitude => _clientLongitude;

  set clientLongitude(double value) {
    _clientLongitude = value;
  }

  int get clientUser => _clientUser;

  set clientUser(int value) {
    _clientUser = value;
  }

  String get clientUserName => _clientUserName;

  set clientUserName(String value) {
    _clientUserName = value;
  }

  String get clientPhoneNumber => _clientPhoneNumber;

  set clientPhoneNumber(String value) {
    _clientPhoneNumber = value;
  }

  String get clientGeoLocation => _clientGeoLocation;

  set clientGeoLocation(String value) {
    _clientGeoLocation = value;
  }

  double get paymentAmount => _paymentAmount;

  set paymentAmount(double value) {
    _paymentAmount = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }


  double get serviceCost => _serviceCost;

  set serviceCost(double value) {
    _serviceCost = value;
  }

  String get learningPeriod => _learningPeriod;

  set learningPeriod(String value) {
    _learningPeriod = value;
  }

  bool get isLearningOrder => _isLearningOrder;

  set isLearningOrder(bool value) {
    _isLearningOrder = value;
  }

  String get scheduleDate => _scheduleDate;

  set scheduleDate(String value) {
    _scheduleDate = value;
  }

  bool get isScheduleOrder => _isScheduleOrder;

  set isScheduleOrder(bool value) {
    _isScheduleOrder = value;
  }

  String get productSerial => _productSerial;

  set productSerial(String value) {
    _productSerial = value;
  }

  String get invoiceNumber => _invoiceNumber;

  set invoiceNumber(String value) {
    _invoiceNumber = value;
  }

  bool get warrantyProduct => _warrantyProduct;

  set warrantyProduct(bool value) {
    _warrantyProduct = value;
  }

  String get brandName => _brandName;

  set brandName(String value) {
    _brandName = value;
  }
}
