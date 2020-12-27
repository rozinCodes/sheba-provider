import 'package:flutter/material.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/widget/all_item_widget.dart';

/*
 * Action bar search (https://github.com/luizeduardotj/searchbarflutterexample)
 * Without actionbar (https://blog.usejournal.com/flutter-search-in-listview-1ffa40956685)
 */
class Search extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.close, size: 20),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<ServiceItem> listExample;
  Search(this.listExample);

  //List<ServiceItem> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ServiceItem> suggestionList = [];
    query.isEmpty
        ? suggestionList = listExample //In the true case {default was 'recentList'}
        : suggestionList.addAll(listExample.where(
          // In the false case
          (element) => element.itemName.toLowerCase().contains(query.toLowerCase()),
    ));

    return Container(
      color: MyColor.colorGrey,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: suggestionList.length,
        itemBuilder: (context, int index) {
          return AllItemWidget(suggestionList[index]);
        },
      ),
    );
  }
}