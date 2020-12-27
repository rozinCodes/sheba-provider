import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/app/config.dart';
import 'package:thikthak/customs/grid_tiles_category.dart';
import 'package:thikthak/models/sales/shop.dart';
import 'package:thikthak/network/http_response.dart';

class ShopHomePage extends StatefulWidget {
  final String slug;
  final bool isSubList;

  ShopHomePage({Key key, this.slug, this.isSubList = false}) : super(key: key);

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  ShopModel shopModel;

  Future<ShopModel> getCategoryList(String slug, bool isSubList) async {
    if (isSubList) {
      shopModel = null;
    }
    if (shopModel == null) {
      var response = await http.get(Config.ROOT_URL + slug);
      Http.printResponse(response);

      if (response.statusCode > 204 && response.body == null) {
        return shopModel;
      } else {
        var body = jsonDecode(response.body);
        shopModel = ShopModel.fromJson(body);
        // brandModel = (body).map((i) =>BrandModel.fromJson(body));
        return shopModel;
      }
    } else {
      return shopModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategoryList(widget.slug, widget.isSubList),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              ShopModel values = snapshot.data;
              List<Data> results = values.data;
              return GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(1.0),
                childAspectRatio: 8.0 / 9.0,
                children: List<Widget>.generate(results.length, (index) {
                  return GridTile(
                      child: GridTilesCategory(
                          name: results[index].shopName,
                          imageUrl: results[index].shopImage,
                          slug: results[index].slug));
                }),
              );
            }
        }
      },
    );
  }
}
