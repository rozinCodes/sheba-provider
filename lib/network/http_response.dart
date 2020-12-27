import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Http {
  static printResponse(Response response) {
    if (kDebugMode && response != null) {
      if (response.request != null) print(response.request);
      if (response.statusCode != null) print(response.statusCode);
      if (response.body != null) log('${response.body}');
      //debugPrint('${response.body}', wrapWidth: 1024);
    }
  }
}
