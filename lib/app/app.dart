import 'package:thikthak/models/place_order.dart';
import 'package:thikthak/models/service_item.dart';

class App {

  static List<ServiceItem> _serviceItem;
  static PlaceOrder _placeOrder;
  static double _techRatingPrice;

  static List<ServiceItem> get serviceItem => _serviceItem;

  static set serviceItem(List<ServiceItem> value) {
    _serviceItem = value;
  }

  static PlaceOrder get placeOrder => _placeOrder;

  static set placeOrder(PlaceOrder value) {
    _placeOrder = value;
  }

  static double get techRatingPrice => _techRatingPrice;

  static set techRatingPrice(double value) {
    _techRatingPrice = value;
  }
}
