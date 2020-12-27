import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/geoservices/location_service.dart';
import 'package:thikthak/models/place_order.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/models/users.dart';
import 'package:thikthak/pages/service_module/nearby_technician.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';

const double CAMERA_ZOOM = 15;
const LatLng INITIAL_LOCATION = LatLng(23.810331, 90.412521);

class DeliveryAddress extends StatefulWidget {
  final ServiceItem serviceItem;
  final bool isLearning;

  DeliveryAddress(this.serviceItem, {this.isLearning = false});

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  String _mapStyle;
  BitmapDescriptor markerIcon;
  LatLng userLocation;
  bool _isLoading = true;
  int _brandChooserValue = 0;
  bool _isCheckboxVisible = true;
  bool _isWarranty = false;

  List<String> _durations = ['3', '5', '7'];
  String _learningDuration;

  var _textServiceNameController = new TextEditingController();
  var _textOrderPersonNameController = new TextEditingController();
  var _textOrderPersonPhoneController = new TextEditingController();
  var _textOrderPersonAddressController = new TextEditingController();
  var _textOrderPersonFlatController = new TextEditingController();
  var _textProblemDetailsController = new TextEditingController();
  var _textProductInvoiceController = new TextEditingController();
  var _textProductSerialController = new TextEditingController();

  final FocusNode myFocusNode = FocusNode();

  void _getCurrentLocation() async {
    var currentLocation = await LocationService().getCurrentLocation();
    userLocation = LatLng(currentLocation.latitude, currentLocation.longitude);

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: userLocation,
    );

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (!mounted) return;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    // stop progress on button
    _stopProgress();
    // plot current location on map
    setState(() {
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId("user_loc"),
          position: userLocation,
          icon: markerIcon));
    });
  }

  /*
   * Retrieve user info from shared
   */
  Future<Null> _getUserInfoFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(prefs.getString('userData'));
    final user = Users.fromJson(userMap);

    if (!mounted) return;
    _textOrderPersonNameController.text = user.displayName;
    _textOrderPersonPhoneController.text = user.phoneNumber;
    _textOrderPersonAddressController.text = user.fullAddress;
  }

  @override
  void initState() {
    super.initState();
    // set custom map style
    rootBundle.loadString('assets/json_assets/map_style.json').then((string) {
      _mapStyle = string;
    });
    generateCustomMarkerIcon();

    _textServiceNameController.text =
        widget.serviceItem.itemName + (widget.isLearning ? '' : ' Servicing');
    _getUserInfoFromShared();
  }

  Future<Null> generateCustomMarkerIcon() async {
    markerIcon = await Utilities.bitmapDescriptorFromSvgAsset(
        context, 'assets/icons/location.svg',
        scale: 0.8);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Address',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Service Name',
                      style: FontUtil.w500S16,
                    ),
                    TextField(
                      controller: _textServiceNameController,
                      style: FontUtil.w400S16,
                      readOnly: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "e.g. AC Installation",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColor.colorBlue),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isLearning,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          Text(
                            'Training Duration',
                            style: FontUtil.w500S16,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black26))),
                            ),
                            hint: Text('Select training duration', style: FontUtil.grey700W400S16),
                            value: _learningDuration,
                            onChanged: (value) {
                              setState(() => _learningDuration = value);
                            },
                            items: _durations.map((String value) {
                              return DropdownMenuItem<String>(
                                child: Text('$value Days', style: FontUtil.w400S16),
                                value: value,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Order Person',
                      style: FontUtil.w500S16,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            style: FontUtil.w400S16,
                            controller: _textOrderPersonNameController,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Type Name",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColor.colorBlue),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.phone,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10.0),
                        Flexible(
                          child: TextField(
                            controller: _textOrderPersonPhoneController,
                            style: FontUtil.w400S16,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(11)
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Phone Number",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColor.colorBlue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text('Location on map',
                          style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: 150.0,
                      width: double.infinity,
                      child: GoogleMap(
                        compassEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        mapType: MapType.normal,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: INITIAL_LOCATION,
                          zoom: CAMERA_ZOOM,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          // Set custom map style
                          controller.setMapStyle(_mapStyle);
                          _controller.complete(controller);
                          // my map has completed being created;
                          // i'm ready to show the pins on the map
                          if (!mounted) return;
                          _getCurrentLocation();
                        },
                      ),
                    ),
                    SizedBox(height: 26.0),
                    Text(
                      'Address',
                      style: FontUtil.w500S16,
                    ),
                    TextField(
                      controller: _textOrderPersonAddressController,
                      style: FontUtil.w400S16,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Enter full address",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColor.colorBlue),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.0),
                    Text(
                      'Flat/Building/Landmark (optional)',
                      style: FontUtil.w500S16,
                    ),
                    TextField(
                      controller: _textOrderPersonFlatController,
                      style: FontUtil.w400S16,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "e.g. beside Dhanmondi 32",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColor.colorBlue),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !widget.isLearning,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 26.0),
                          Text(
                            'Problem Details (optional)',
                            style: FontUtil.w500S16,
                          ),
                          TextField(
                            controller: _textProblemDetailsController,
                            style: FontUtil.w400S16,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Type message",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColor.colorBlue),
                              ),
                            ),
                          ),
                          SizedBox(height: 26.0),
                          Text(
                            'Brand Type',
                            style: FontUtil.w500S16,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  child: RadioListTile(
                                    value: 0,
                                    groupValue: _brandChooserValue,
                                    title: Text('Walton', style: FontUtil.w400S16),
                                    onChanged: (value) {
                                      setState(() {
                                        _brandChooserValue = value;
                                        _isCheckboxVisible = true;
                                      });
                                    },
                                    dense: true,
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListTileTheme(
                                  contentPadding: EdgeInsets.all(0),
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: _brandChooserValue,
                                    title: Text('Others', style: FontUtil.w400S16),
                                    onChanged: (value) {
                                      setState(() {
                                        _brandChooserValue = value;
                                        _isCheckboxVisible = false;
                                        _isWarranty = false;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    dense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _isCheckboxVisible,
                            child: ListTileTheme(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              child: CheckboxListTile(
                                title: Text('Warranty product',
                                    style: FontUtil.blackW400S14),
                                value: _isWarranty,
                                onChanged: (value) {
                                  setState(() => _isWarranty = value);
                                },
                                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isWarranty,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    style: FontUtil.w400S16,
                                    controller: _textProductInvoiceController,
                                    textCapitalization: TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Invoice No",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: MyColor.colorBlue),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: TextField(
                                    style: FontUtil.w400S16,
                                    controller: _textProductSerialController,
                                    textCapitalization: TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Product Serial No",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: MyColor.colorBlue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(13.0),
                        color: MyColor.colorBlue,
                        textColor: Colors.white,
                        child: _setUpButtonChild(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        onPressed: () {
                          if (!_isLoading) _validateInput();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _setUpButtonChild() {
    if (_isLoading) {
      return SizedBox(
        width: 18.0,
        height: 18.0,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.5),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: MediaQuery.of(context).size.width * 0.05),
          Text(
            'Proceed',
            style: FontUtil.whiteW500S14,
          ),
          Icon(Icons.arrow_forward, size: 16),
        ],
      );
    }
  }

  void _stopProgress() {
    setState(() {
      _isLoading = false;
    });
  }

  _validateInput() {
    if (widget.isLearning && _learningDuration == null) {
      Util.showColorToast('Please select your training duration', Colors.red);
      return;
    }
    // Check for name, phone, address empty or not
    if (_textOrderPersonNameController.text.isEmpty) {
      Util.showColorToast('Enter the person name', Colors.red);
      return;
    } else if (_textOrderPersonPhoneController.text.length < 11) {
      Util.showColorToast('Invalid phone number', Colors.red);
      return;
    } else if (_textOrderPersonAddressController.text.length < 15) {
      Util.showColorToast('Write address in details (Min 15 letter)', Colors.red);
      return;
    } else if (_isWarranty && _textProductInvoiceController.text.isEmpty) {
      Util.showColorToast('Invoice number is required', Colors.red);
      return;
    } else if (_isWarranty && _textProductSerialController.text.isEmpty) {
      Util.showColorToast('Product serial number is required', Colors.red);
      return;
    }

    _navigateToNNearbyTechnician();
  }

  /*
   * Goto nearby technician page
   */
  _navigateToNNearbyTechnician() {
    // Save values to application
    PlaceOrder placeOrder = PlaceOrder();
    placeOrder.serviceItemName = widget.serviceItem.itemName;
    placeOrder.serviceItemCode = widget.serviceItem.itemCode;
    // paymentAmount = minPrice + techRatingPrice
    placeOrder.paymentAmount = widget.serviceItem.minPrice + widget.serviceItem.techRatingPrice;
    placeOrder.clientUser = ConstantValues.userId;
    placeOrder.clientUserName = _textOrderPersonNameController.text.trim();
    placeOrder.clientPhoneNumber = _textOrderPersonPhoneController.text.trim();
    placeOrder.clientGeoLocation = _textOrderPersonAddressController.text.trim();
    placeOrder.clientLatitude = userLocation.latitude;
    placeOrder.clientLongitude = userLocation.longitude;
    placeOrder.serviceDetailsDesc = _textProblemDetailsController.text.trim();
    placeOrder.brandName = _brandChooserValue == 0 ? 'Walton' : 'Others';
    placeOrder.warrantyProduct = _isWarranty;
    placeOrder.invoiceNumber = _textProductInvoiceController.text.trim();
    placeOrder.productSerial = _textProductSerialController.text.trim();
    placeOrder.isLearningOrder = widget.isLearning;
    placeOrder.learningPeriod = _learningDuration;

    App.placeOrder = placeOrder;
    App.techRatingPrice = widget.serviceItem.techRatingPrice;

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NearbyTechnician()));
  }
}
