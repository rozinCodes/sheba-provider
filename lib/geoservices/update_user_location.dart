import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/geoservices/location_service.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';

/// src
/// https://flutter.dev/docs/cookbook/networking/fetch-data
/// https://flutter.dev/docs/cookbook/networking/send-data
/// https://medium.com/swlh/how-to-make-http-requests-in-flutter-d12e98ee1cef
class UpdateUserLocation {

  void update() async {
    debugPrint('Updating location...');
    final Position currentLocation = await LocationService().getCurrentLocation();
    final String accessToken = await auth.token;

    // validation before send
    if (accessToken == null) {
      print("api authorize token not set yet !..");
      return;
    }

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: accessToken,
    };

    Map<String, dynamic> data = {
      "userId": ConstantValues.userId,
      "latitude": currentLocation.latitude,
      "longitude": currentLocation.longitude,
    };

    //encode Map to JSON
    var body = jsonEncode(data);
    print(body);

    try {
      http.post(Config.USER_LOCATION_UPDATE, headers: headers, body: body)
          .timeout(Duration(minutes: 1), onTimeout: () {
        return;
      }).then((response) {
        Http.printResponse(response);
      });
    } on Exception catch (exception) {
      print('exception $exception');  // only executed if error is of type Exception
    } catch (error) {
      print('error $error');  // executed for errors of all types other than Exception
    }
  }
}
