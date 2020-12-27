import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thikthak/app/config.dart';

// https://stackoverflow.com/a/63967005/5280371
class Auth {

  static String _type;
  static String _token;
  static DateTime _expiryDate;
  //Timer _authTimer;

  Future<String> get token async {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return '$_type $_token';
    }
    //refreshSession();
    return await refreshSession();
  }

  Future<String> refreshSession() async {
    print('refreshSession...');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    Map data = {'username': 'system', 'password': 'system'};
    // encode Map to JSON
    var body = json.encode(data);

    try {
      final response = await http.post(Config.GENERATE_ACCESS_TOKEN, headers: headers, body: body)
          .timeout(Duration(seconds: 15));

      final responseData = json.decode(response.body);
      if (response == null || response.body == null || response.statusCode > 204) {
        return null;
      }
      _type = responseData['token_type'];
      _token = responseData['access_token'];
      _expiryDate = DateTime.now().add(Duration(seconds: responseData['expires_in']));

      /*if(_authTimer != null) {
        _authTimer.cancel();
      }
      final timeToExpiry =  _expiryDate.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpiry), refreshSession);*/
      return '$_type $_token';

    } on Exception catch (exception) {
      print('exception $exception');
      return null;
    }
  }
}

final auth = Auth();