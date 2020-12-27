import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rxdart/subjects.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/models/required_parts.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/utils/util.dart';

final BehaviorSubject<void> addCostCallback = BehaviorSubject<void>();

class RequiredPartsPage extends StatefulWidget {
  final OrderHistory order;
  RequiredPartsPage({@required this.order});

  @override
  _RequiredPartsPageState createState() => _RequiredPartsPageState();
}

class _RequiredPartsPageState extends State<RequiredPartsPage> {
  ProgressDialog _progressDialog;
  final _nameController = List<TextEditingController>();
  final _idController = List<TextEditingController>();
  RequiredParts _requiredParts = new RequiredParts();

  final List<Map> _dropdownItems = [
    {"id": "serviceCost", "name": "Service Cost"},
    {"id": "partsCost", "name": "Parts Cost"},
    {"id": "tadaCost", "name": "TA Cost"},
    {"id": "othersCost", "name": "Others"}
  ];

  double _totalPrice = 0.0;

  addDynamic() {
    setState(() => _requiredParts.addParts({"name": "serviceCost", "price": ""}));
  }

  removeDynamic(index) {
    setState(() => _requiredParts.removeParts(index));
  }

  void onCostAddSuccess(){
    Navigator.pop(context);
    /// add callback listener
    addCostCallback.add(VoidCallback);
  }

  /*submitData() {
    floatingIcon = new Icon(Icons.arrow_back);
    data = [];
    listDynamic.forEach((widget) => data.add(widget.controller.text));
    setState(() {});
    print(data.length);
  }*/

  @override
  void initState() {
    super.initState();
    // default add service cost in the list
    Map _results = widget.order.addCost.toJson();
    for (var entry in _results.entries) {
      if(entry.value != null && entry.value > 0.0)
      _requiredParts.addParts({"name": entry.key, "price": "${entry.value}"});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: ListView(
          padding: EdgeInsets.only(bottom: 50),
          // if you have non-mini FAB else use 40
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: _buildFields(_requiredParts.parts.length),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: addDynamic,
                child: RichText(
                  text: TextSpan(
                    text: '+ ',
                    style: FontUtil.themeColorW600S18,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Add new',
                        style: FontUtil.themeColorW500S14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: showFab
            ? Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total: ',
                        style: FontUtil.black87W600S18,
                      ),
                      Text(
                        ConstantValues.CURRENCY_SYMBOL + '${_totalPrice.toStringAsFixed(2)}',
                        style: FontUtil.black87W600S18,
                      ),
                      Spacer(),
                      SizedBox(
                        height: 42.0,
                        child: RaisedButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          child: Text("Submit"),
                          textColor: Colors.white,
                          color: MyColor.colorBlue,
                          onPressed: () {
                            // making data as a raw json format
                            Map<String, dynamic> _data = new Map();
                            _data['id'] = widget.order.id;
                            for (var array in _requiredParts.parts) {
                              var price = array['price'].toString();
                              if (price.isNotEmpty && double.parse(price) > 0.0)
                                _data[array['name']] = double.parse(price);
                            }
                            // request to server
                            _addCost(_data);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }

  List<Widget> _buildFields(int length) {
    _idController.clear();
    _nameController.clear();
    _totalPrice = 0.0;

    for (int i = 0; i < length; i++) {
      String name = _requiredParts.parts[i]["name"];
      String price = _requiredParts.parts[i]["price"];
      _idController.add(TextEditingController(text: name));
      _nameController.add(TextEditingController(text: price));

      _totalPrice += price.isNotEmpty ? double.parse(price) : 0.0;
    }
    return List<Widget>.generate(length, (i) => _productEdit(i, _idController[i], _nameController[i]));
  }

  Widget _productEdit(index, idController, priceController) {
    String name = _requiredParts.parts[index]["name"];

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "${index + 1}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          flex: 6,
          child: SizedBox(
            height: 36.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[500])),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: name.isNotEmpty ? name : 'serviceCost',
                  icon: Icon(Icons.arrow_drop_down, size: 20),
                  onChanged: (value) {
                    setState(() {
                      _requiredParts.editParts(index, "name", value);
                    });
                  },
                  items: _dropdownItems.map((Map map) {
                    return DropdownMenuItem<String>(
                      value: map["id"],
                      child: Text(map["name"],
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        /*Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 6),
            child: SizedBox(
              height: 36.0,
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: MyColor.colorBlue),
                  ),
                  contentPadding: EdgeInsets.only(left: 12, bottom: 12),
                ),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                onChanged: (value) {
                  _dataState.editParts(index, "name", value);
                },
              ),
            ),
          ),
        ),*/
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 6),
            child: SizedBox(
              height: 36.0,
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: MyColor.colorBlue),
                  ),
                  contentPadding: EdgeInsets.only(left: 10, bottom: 12),
                ),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                onChanged: (value) {
                  _requiredParts.editParts(index, "price", value);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            padding: new EdgeInsets.all(0.0),
            icon: Icon(
              Icons.delete,
              size: 16,
              color: Colors.red,
            ),
            onPressed: () => removeDynamic(index),
          ),
        ),
      ],
    );
  }

  /*
   * Add cost
   */
  Future<Null> _addCost(Map data) async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    // encode Map to JSON
    var body = jsonEncode(data);

    try {
      final response = await http.post(Config.ADD_COST, headers: headers, body: body);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }
      // show success message
      var json = jsonDecode(response.body);
      Util.showColorToast(json['message'], Colors.green);

      // callback method
      onCostAddSuccess();
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}
