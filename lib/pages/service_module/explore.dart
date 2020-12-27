import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thikthak/geoservices/location_service.dart';
import 'package:thikthak/utils/utilities.dart';

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 30;
const double CAMERA_BEARING = 90;
const LatLng INITIAL_LOCATION = LatLng(23.810331, 90.412521);

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  String _mapStyle;

  // for my custom marker pins
  BitmapDescriptor markerIcon;

  @override
  void initState() {
    super.initState();
    // set custom map style
    rootBundle.loadString('assets/json_assets/map_style.json').then((string) {
      _mapStyle = string;
    });

    // set custom marker pins
    setTechnicianIcons();
  }

  void setTechnicianIcons() async {
    markerIcon = await Utilities.bitmapDescriptorFromSvgAsset(
        context, 'assets/icons/marker.svg');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
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
                target: INITIAL_LOCATION,
                zoom: CAMERA_ZOOM,
              ),
              onMapCreated: (GoogleMapController controller) {
                // Set custom map style
                controller.setMapStyle(_mapStyle);
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                _getCurrentLocation();
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
          ],
        ),
        floatingActionButton: SizedBox(
          height: 46.0,
          width: 46.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _getCurrentLocation,
            tooltip: 'Get Location',
            child: Icon(Icons.my_location, color: Colors.indigo),
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    var currentLocation = await LocationService().getCurrentLocation();
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final marker1 = Marker(
      markerId: MarkerId("tech_1"),
      position: LatLng(
          currentLocation.latitude + 0.002, currentLocation.longitude + 0.002),
      icon: markerIcon,
    );

    final marker2 = Marker(
      markerId: MarkerId("tech_2"),
      position: LatLng(
          currentLocation.latitude - 0.002, currentLocation.longitude - 0.002),
      icon: markerIcon,
    );

    final marker3 = Marker(
      markerId: MarkerId("tech_3"),
      position: LatLng(
          currentLocation.latitude + 0.001, currentLocation.longitude - 0.002),
      icon: markerIcon,
    );

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (!mounted) return;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      _markers.clear();
      _markers.add(marker1);
      _markers.add(marker2);
      _markers.add(marker3);
    });
  }
}
