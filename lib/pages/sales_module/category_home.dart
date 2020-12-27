import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/customs/grid_tiles_category.dart';
import 'package:thikthak/models/sales/category.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  final String slug;
  final bool isSubList;

  CategoryPage({Key key, this.slug, this.isSubList = false}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> categories;

  Future<List<CategoryModel>> getCategoryList(
      String slug, bool isSubList) async {
    if (isSubList) {
      categories = null;
    }
    if (categories == null) {
      var response = await http.get(Config.ROOT_URL + slug);
      Http.printResponse(response);

      if (response.statusCode > 204 && response.body == null) {
        return [];
      } else {
        var body = jsonDecode(response.body);
        categories = (body as List).map((i) => CategoryModel.fromJson(i)).toList();
        return categories;
      }
    } else {
      return categories;
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
              List<CategoryModel> values = snapshot.data;
              return GridView.count(
                crossAxisCount: 3,
                // physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(1.0),
                childAspectRatio: 8.0 / 9.0,
                children: List<Widget>.generate(values.length, (index) {
                  return GridTile(
                    child: GridTilesCategory(
                      name: values[index].name,
                      imageUrl: values[index].imageUrl,
                      slug: values[index].slug,
                      fromSubProducts: widget.isSubList,
                    ),
                  );
                }),
              );
            }
        }
      },
    );
  }
}
