import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/favourite_technician.dart';

class FavouriteListWidget extends StatefulWidget {
  final FavouriteTechnician item;
  final VoidCallback remove;

  FavouriteListWidget(this.item, {this.remove});

  @override
  _FavouriteListWidgetState createState() => _FavouriteListWidgetState();
}

class _FavouriteListWidgetState extends State<FavouriteListWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.asset('assets/images/ic_expert.png', scale: 4),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                                color: MyColor.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(bottom: 6.0)),
                          Text(
                            widget.item.expertiseArea,
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                color: MyColor.textColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red.withOpacity(0.8),
                      size: 18.0,
                    ),
                    onPressed: widget.remove,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
