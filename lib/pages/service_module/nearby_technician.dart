import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/customs/map_pin_pill.dart';
import 'package:thikthak/models/pin_pill_info.dart';
import 'package:thikthak/models/place_order.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/service_module/order_booking.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 30;
const double CAMERA_BEARING = 90;
const LatLng INITIAL_LOCATION = LatLng(23.810331, 90.412521);

class NearbyTechnician extends StatefulWidget {
  @override
  _NearbyTechnicianState createState() => _NearbyTechnicianState();
}

class _NearbyTechnicianState extends State<NearbyTechnician> {
  /// Progress dialog
  ProgressDialog _progressDialog;

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  String _mapStyle;

  // for my custom marker pins
  BitmapDescriptor markerIcon;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      techId: 0,
      techName: '',
      techPhoto: "assets/images/avatar.png",
      expertiseArea: '',
      techRating: 0.0,
      techLatitude: 0.0,
      techLongitude: 0.0);

  bool _isTechnicianFound = true;
  String defaultText =
      "You can choose technician manually by taping on the marker. If you don\'t want this just press 'Skip Map'. Our system will choose best technician for you.";
  String errorText =
      "Sorry, no nearby technician found! Please press 'Skip Map'. We will assign a perfect technician for you to provide better service.";

  // Get place order details
  PlaceOrder placeOrder = App.placeOrder;
  double techRatingPrice = App.techRatingPrice;
  double servicePrice;

  void _getNearbyTechnician() async {
    // Show progress dialog
    await _progressDialog.show();

    final queryParameters = {
      'itemCode': placeOrder.serviceItemCode,
      'custLatitude': '${placeOrder.clientLatitude}',
      'custLongitude': '${placeOrder.clientLongitude}',
    };

    var uri = Uri.parse(Config.NEAREST_TECHNICIAN);
    uri = uri.replace(queryParameters: queryParameters);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    try {
      var response = await http.get(uri, headers: headers).timeout(Duration(seconds: 30));
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      if(_progressDialog.isShowing()) await _progressDialog.hide();
      // Plot marker on map
      _plotTechnician(jsonDecode(response.body));

    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  @override
  void initState() {
    super.initState();
    // set default price for service
    servicePrice = placeOrder.paymentAmount;
    // set custom map style
    rootBundle.loadString('assets/json_assets/map_style.json').then((string) {
      _mapStyle = string;
    });
    // set custom marker pins
    _generateCustomMarkerIcon();
  }

  void _generateCustomMarkerIcon() async {
    markerIcon = await Utilities.bitmapDescriptorFromSvgAsset(
        context, 'assets/icons/marker.svg');
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              zoom: CAMERA_ZOOM,
              tilt: CAMERA_TILT,
              bearing: CAMERA_BEARING,
              target: INITIAL_LOCATION,
            ),
            onMapCreated: (GoogleMapController controller) {
              // Set custom map style
              controller.setMapStyle(_mapStyle);
              _controller.complete(controller);
              // my map has completed being created;
              // i'm ready to show the pins on the map
              _getNearbyTechnician();
            },
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -100;
              });
            },
          ),

          // Action bar back button
          Padding(
            padding: EdgeInsets.only(top: 28, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.white,
                  elevation: 3.0,
                  constraints: BoxConstraints.tightFor(
                    width: 36.0,
                    height: 36.0,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),

          // Center notice card
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 80, right: 60, left: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 15,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Text(
                  _isTechnicianFound ? defaultText : errorText,
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        fontSize: 12.5,
                        color: _isTechnicianFound ? Colors.black87 : Colors.red,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ),
          ),

          // Skip Map button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                color: MyColor.colorBlue,
                textColor: Colors.white,
                elevation: 3,
                child: Text(
                  'Skip Map',
                  style: FontUtil.whiteW500S15,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () => _placeOrder(),
              ),
            ),
          ),

          // Custom infoWindow
          MapPinPillComponent(
            pinPillPosition: pinPillPosition,
            currentlySelectedPin: currentlySelectedPin,
            onPressed: () => _placeOrder(
                currentlySelectedPin.techId,
                currentlySelectedPin.techLatitude,
                currentlySelectedPin.techLongitude,
                currentlySelectedPin.techName,
                currentlySelectedPin.techRating),
          ),
        ],
      ),
    );
  }

  void _plotTechnician(List<dynamic> nearbyTech) async {
    List<Marker> markerList = [];

    // Handle error if nearby technician not found
    if (nearbyTech.length == 0) {
      setState(() => _isTechnicianFound = false);
      return;
    }

    for (var tech in nearbyTech) {
      PinInformation techPinInformation = PinInformation(
          techId: tech['techId'],
          techPhoto: "assets/images/avatar.png",
          techName: tech['techName'],
          expertiseArea: tech['expertiseArea'],
          techRating: tech['techRating'],
          techLatitude: tech['techLatitude'],
          techLongitude: tech['techLongitude']);

      Marker marker = Marker(
        markerId: MarkerId("tech_${tech['techId']}"), // marker id must be unique
        position: LatLng(tech['techLatitude'], tech['techLongitude']),
        onTap: () {
          setState(() {
            currentlySelectedPin = techPinInformation;
            pinPillPosition = 0;
          });
        },
        icon: markerIcon,
      );
      markerList.add(marker);
    }

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (!mounted) return;
    setState(() {
      for (var marker in markerList) {
        _markers.add(marker);
      }
    });

    // calculate LatLngBounds padding
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var minMetric = min(width, height);
    var padding = (minMetric * 0.40); // offset from edges of the map in pixels

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLngBounds(getBounds(markerList), padding));
  }

  /// https://stackoverflow.com/a/58503902/5280371
  /// https://stackoverflow.com/a/55990256/5280371
  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
    return bounds;
  }

  /*
   * Request for order place
   */
  void _placeOrder([int id, double lat, double lng, String name, double rating]) {
    // Assign current selected technician info
    placeOrder.technicianUser = id;
    placeOrder.techLatitude = lat;
    placeOrder.techLongitude = lng;
    placeOrder.technicianUserName = name;

    if(rating == null) {
      // if user skip map then default price will be set
      placeOrder.paymentAmount = servicePrice;
    } else {
      // calculate price based on technician rating
      double minPrice = servicePrice - techRatingPrice;
      double calculatedServicePrice = minPrice + (techRatingPrice * (rating / 100) /* % of rating */);
      placeOrder.paymentAmount = (calculatedServicePrice * 100).round() / 100; // make precise value
      debugPrint('minPrice $minPrice, techRatingPrice $techRatingPrice, servicePrice $calculatedServicePrice');
    }

    debugPrint('data: $id, $lat, $lng, $name, ${placeOrder.paymentAmount}');

    // Goto order booking page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderBooking()));
  }
}
