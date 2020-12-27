import 'package:flutter/material.dart';
import 'package:thikthak/customs/promo_slider.dart';
import 'package:thikthak/customs/search_widget.dart';
import 'package:thikthak/models/sales/popular_menu.dart';
import 'package:thikthak/pages/sales_module/category_home.dart';
import 'package:thikthak/pages/sales_module/shop_home.dart';

class SalesHome extends StatefulWidget {
  @override
  _SalesHomeState createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SearchWidget(),
          TopPromoSlider(),
          PopularMenu(),
          SizedBox(
            height: 10,
            child: Container(
              color: Color(0xFFf5f6f7),
            ),
          ),
          PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Categories',
                ),
                Tab(
                  text: 'Brands',
                ),
                Tab(
                  text: 'Shops',
                )
              ], // list of tabs
            ),
          ),
          SizedBox(
            height: 10,
            child: Container(
              color: Color(0xFFf5f6f7),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  color: Colors.white24,
                  child: CategoryPage(slug: 'categories/'),
                ),
                Container(
                  color: Colors.white24,
                  //child: BrandHomePage(slug: 'brands/?limit=20&page=1'),
                  child: ShopHomePage(slug: 'custom/shops/?page=1&limit=15'),
                ),
                Container(
                  color: Colors.white24,
                  child: ShopHomePage(slug: 'custom/shops/?page=1&limit=15'),
                ) // class name
              ],
            ),
          ),
        ],
      ),
    );
  }
}
