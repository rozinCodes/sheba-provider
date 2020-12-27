import 'package:flutter/material.dart';
import 'package:thikthak/customs/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/pin_pill_info.dart';
import 'package:thikthak/utils/utilities.dart';

class MapPinPillComponent extends StatefulWidget {
  final double pinPillPosition;
  final PinInformation currentlySelectedPin;
  final VoidCallback onPressed;

  MapPinPillComponent({this.pinPillPosition, this.currentlySelectedPin, this.onPressed});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  final TextStyle _textStyleLabel = GoogleFonts.ubuntu(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: MyColor.colorBlue,
      decoration: TextDecoration.none);
  final TextStyle _textStyleBody = GoogleFonts.ubuntu(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.grey[850],
      decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 10),
                child: ClipOval(
                    child: Image.asset(
                        widget.currentlySelectedPin.techPhoto,
                        fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Utilities.isValidateMobile(
                                widget.currentlySelectedPin.techName)
                            ? 'Unknown Name' // Hide technician number from user when place order
                            : widget.currentlySelectedPin.techName,
                        style: _textStyleLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.currentlySelectedPin.expertiseArea,
                        style: _textStyleBody,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBarIndicator(
                            rating: widget.currentlySelectedPin.techRating / 20, // Convert max (100) rating to 5
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 16.0,
                            /*itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),*/
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star, color: Colors.amber),
                              half: Icon(Icons.star_half, color: Colors.amber),
                              empty: Icon(Icons.star_border, color: Colors.amber),
                            ),
                            unratedColor: Colors.amber,
                          ),
                          SizedBox(width: 6),
                          Text('(${widget.currentlySelectedPin.techRating.toStringAsFixed(1)})',
                            style: _textStyleBody,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: MyColor.colorBlue,
                  elevation: 0.0,
                  constraints: BoxConstraints.tightFor(
                    width: 38.0,
                    height: 38.0,
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: widget.onPressed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
