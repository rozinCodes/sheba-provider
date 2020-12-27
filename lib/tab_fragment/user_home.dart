import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/customs/carousel.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/pages/notification.dart';
import 'package:thikthak/pages/service_module/all_service.dart';
import 'package:thikthak/pages/service_module/delivery_address.dart';
import 'package:thikthak/pages/service_module/search.dart';
import 'package:thikthak/utils/font_util.dart';

class Services {
  String name;
  String icon;
  int serviceCode;
  double minPrice;

  // constructor
  Services(this.name, this.icon, this.serviceCode, this.minPrice);
}

class HomeFragmentUser extends StatefulWidget {
  @override
  _HomeFragmentUserState createState() => _HomeFragmentUserState();
}

class _HomeFragmentUserState extends State<HomeFragmentUser> {
  int _notificationCount = 0;

  // All service list
  List<ServiceItem> serviceItemList = App.serviceItem;

  @override
  void initState() {
    super.initState();

    /// Callback listener
    notificationSubject.stream.listen((int count) async {
      if (!mounted) return;
      setState(() => _notificationCount = count);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.colorBackground,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ListView(
            children: <Widget>[
              SliderFrame(),
              GridView.count(
                crossAxisCount: 4,
                physics: ScrollPhysics(),
                // to disable GridView's scrolling
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 12),
                children: List<Widget>.generate(serviceItemList.length < 12 ? serviceItemList.length : 12, (index) {
                  final imagePath = serviceItemList[index].iconImgPath;
                  return GridTile(
                    child: Card(
                      color: Colors.white,
                      elevation: 0.0,
                      margin: EdgeInsets.all(1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                        //splashColor: Colors.green,
                        onTap: () {
                          // Goto order page
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DeliveryAddress(serviceItemList[index])));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FadeInImage.assetNetwork(
                                  imageScale: 4.0,
                                  placeholderScale: 5.5,
                                  placeholder: 'assets/images/placeholder.png',
                                  image: imagePath != null ? Config.BASE_URL + imagePath : ''),
                              SizedBox(height: 8),
                              Text(
                                serviceItemList[index].itemName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: MyColor.colorBlack),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400),
                              ) // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              // View More
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Text(
                    "View All",
                    style: FontUtil.themeColorW500S14,
                  ),
                  onPressed: () {
                    // goto all service item page
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AllService()));
                  },
                ),
              ),

              // Computer/Laptop learning
              Card(
                color: Colors.white,
                elevation: 0.0,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  visualDensity: VisualDensity(horizontal: 4.0, vertical: -1.5),
                  leading: SizedBox(
                    width: 60.0,
                    child: (SvgPicture.asset('assets/icons/training.svg')),
                  ),
                  title: Text(
                    'Learn Computer',
                    style: FontUtil.themeColorW600S16,
                  ),
                  subtitle: Text(
                    'in 3, 5 or 7 Days',
                    style: FontUtil.grey700W400S13,
                  ),
                  trailing: Card(
                    shape: CircleBorder(),
                    color: MyColor.colorBlue.withAlpha(25),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(Icons.keyboard_arrow_right,
                          color: MyColor.colorBlue),
                    ),
                  ),
                  onTap: () {
                    // make learning service
                    ServiceItem learningService = ServiceItem(itemName: 'Computer Learning', itemCode: '0000', minPrice: 200, techRatingPrice: 0);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DeliveryAddress(learningService, isLearning: true,)));
                  },
                ),
              ),

              // Promo banner ads
              ClipRect(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset('assets/images/banner.png'),
                ),
              ),
            ],
          ),

          // Top panel Search & Notification
          Positioned(
            top: 26,
            right: 5,
            child: FloatingActionButton(
              heroTag: "notification",
              tooltip: 'Notification',
              onPressed: _gotoNotification,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: _notificationCount > 0
                  ? Badge(
                      position: BadgePosition.topEnd(top: -12),
                      animationDuration: Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.fade,
                      badgeColor: Colors.red,
                      badgeContent: Text(
                        '$_notificationCount',
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(color: Colors.white),
                          fontSize: 12,
                        ),
                      ),
                      child: Icon(Icons.notifications),
                    )
                  : Icon(Icons.notifications),
            ),
          ),
          Positioned(
            top: 26,
            right: 50,
            child: FloatingActionButton(
              heroTag: "search",
              tooltip: 'Search',
              onPressed: () {
                showSearch(context: context, delegate: Search(App.serviceItem));
              },
              child: Icon(Icons.search),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _gotoNotification() {
    // reset counter
    setState(() => _notificationCount = 0);

    // Goto notification page
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NotificationPage()));
  }
}
