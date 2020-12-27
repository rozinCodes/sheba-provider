import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/favourite_technician.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/widget/favourite_list_widget.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  /// Empty list
  Future<List<FavouriteTechnician>> _favouriteList;

  /*
   * Request for user order list
   */
  Future<List<FavouriteTechnician>> _getFavouriteTechnician() async {
    final userParam = {'clientUserId': '${ConstantValues.userId}'};

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.FAVOURITE_LIST);
    uri = uri.replace(queryParameters: userParam);

    try {
      final response = await http.get(uri, headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        return []; // something error
      } else {
        List<dynamic> data = jsonDecode(response.body);
        List<FavouriteTechnician> list = data.map((dynamic item) => FavouriteTechnician.fromJson(item)).toList();
        return list;
      }
    } on Exception catch (e, _) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _favouriteList = _getFavouriteTechnician();
  }

  Future<void> refreshList() {
    setState(() {
      _favouriteList = _getFavouriteTechnician();
    });
    return _favouriteList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite Technician',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: MyColor.colorGrey,
        child: FutureBuilder(
          future: _favouriteList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text(
                    'Favourite list is empty',
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              List favouriteTech = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: favouriteTech.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavouriteListWidget(favouriteTech[index],
                  remove: () => _removeFromFavourite(favouriteTech[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _removeFromFavourite(FavouriteTechnician favList) async {

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    try {
      final response = await http.delete(Config.FAVOURITE_LIST + '/${favList.id}', headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }
      Util.showToast('Technician removed from favourite');
      refreshList();
    } on Exception catch (e, _) {
      Util.showErrorToast();
    }
  }
}
