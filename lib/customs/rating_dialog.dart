import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/customs/simple_rating.dart';
import 'package:tuple/tuple.dart';

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0.0;
  var _reviewController = new TextEditingController();

  /*List<Widget> _buildStarRatingButtons() {
    List<Widget> buttons = [];

    for (int rateValue = 1; rateValue <= 5; rateValue++) {
      final starRatingButton = IconButton(
          icon: Icon(_rating >= rateValue ? Icons.star : Icons.star_border,
              color: widget.accentColor, size: 35),
          onPressed: () {
            setState(() {
              _rating = rateValue;
            });
          });
      buttons.add(starRatingButton);
    }

    return buttons;
  }*/

  @override
  Widget build(BuildContext context) {
    // final Color commentColor = _rating >= 4 ? Colors.green[600] : Colors.red;

    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*RatingBar(
                  allowHalfRating: true,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 35.0,
                  initialRating: 2.3,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: widget.accentColor),
                    half: Icon(Icons.star_half, color: widget.accentColor),
                    empty: Icon(Icons.star_border, color: widget.accentColor),
                  ),
                  unratedColor: widget.accentColor,
                  onRatingUpdate: (value) {
                    setState(() => _rating = value);
                  },
                ),*/
                SimpleRating(
                  useHalfRating: true,
                  onChanged: (value) {
                    setState(() => _rating = value);
                  },
                  starCount: 5,
                  rating: _rating,
                  size: 35,
                  color: widget.accentColor,
                  borderColor: widget.accentColor,
                  spacing: 0.0,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Rating: ${(_rating * 20).toInt()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Visibility(
              visible: _rating > 0.0,
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: widget.showCommentBox,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: widget.accentColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: widget.accentColor)),
                          hintText: "Write Review",
                          //border: InputBorder.none,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  //const Divider(),
                  RaisedButton(
                    color: widget.accentColor,
                    child: Text(
                      widget.submitButton,
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSubmitPressed(Tuple2(_rating, _reviewController.text));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String title;
  final String description;
  final String submitButton;
  final Color accentColor;
  final bool showCommentBox;
  final ValueSetter<Tuple2<double, String>> onSubmitPressed;

  RatingDialog(
      {@required this.title,
      @required this.description,
      @required this.onSubmitPressed,
      @required this.submitButton,
      this.accentColor = Colors.indigo,
      this.showCommentBox = false});

  @override
  _RatingDialogState createState() => new _RatingDialogState();
}
