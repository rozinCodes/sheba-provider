import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/users.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/shared/pref_manager.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';

class Profile extends StatefulWidget {
  final bool editable;
  final bool goHome;

  // receive data from the previous as a parameter
  Profile({Key key, this.editable, this.goHome}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  /*
   *  TextEditingController - This will be used as a controller for listening to the changes what the user is entering
   *  and it's listener will take care of the rest
   */
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _editable = false;
  bool _goHome = false;

  bool _isTechnician = false;
  final FocusNode myFocusNode = FocusNode();

  Map<String, bool> expertiseList = {
    'Refrigerator & Freezer': false,
    'Television': false,
    'Mobile Phone': false,
    'Laptop & Computer': false,
    'Air Conditioner': false,
    'Washing Machine': false,
    'Home Appliances': false,
    'Electrical Appliances': false,
    'Elevator': false
  };

  /// DropdownList for city
  List<String> cityList = [];

  final TextStyle _textStyleRegular =
      GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w400);
  final TextStyle _textStyleMedium =
      GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w500);

  /// Session manager class
  PrefsManager _prefs = PrefsManager();

  /// Progress dialog
  ProgressDialog _progressDialog;
  File _image;
  final picker = ImagePicker();
  String _imageName = ConstantValues.imageName;

  /*
   * Choose image from gallery
   */
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageUpload();
      }
    });
  }

  /*
   * Gender chooser dialog
   */
  void _chooseGender(BuildContext context) async {
    var _userChooserValue = 0;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Select Gender',
              style: GoogleFonts.ubuntu(
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio<int>(
                          value: 0,
                          groupValue: _userChooserValue,
                          onChanged: (value) {
                            setState(() => _userChooserValue = value);
                          },
                        ),
                        Text('Male', style: _textStyleRegular),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio<int>(
                          value: 1,
                          groupValue: _userChooserValue,
                          onChanged: (value) {
                            setState(() => _userChooserValue = value);
                          },
                        ),
                        Text('Female', style: _textStyleRegular),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio<int>(
                          value: 2,
                          groupValue: _userChooserValue,
                          onChanged: (value) {
                            setState(() => _userChooserValue = value);
                          },
                        ),
                        Text('Other', style: _textStyleRegular),
                      ],
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Update textField
                  _genderController.text = _userChooserValue == 0
                      ? 'Male'
                      : _userChooserValue == 1 ? 'Female' : 'Other';
                },
              ),
            ],
          );
        });
  }

  /*
   * Date picker dialog
   */
  void _selectDate(BuildContext context,
      {DateTime selectedDate}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = '${DateFormat("yyyy-MM-dd").format(picked.toLocal())}';
      });
    }
  }

  /*
   * City chooser dialog
   */
  void _showCityListModal() async {
    // read JSON file
    String cityMap = await rootBundle.loadString('assets/json_assets/bd_cities.json');
    var jsonData = jsonDecode(cityMap);
    for (var data in jsonData) {
      cityList.add(data['city']);
    }

    String selectedCity = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select City', style: _textStyleMedium),
            children: cityList.map((city) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, city); //here passing the value to be return on item selection
                },
                child: Text(city, style: _textStyleRegular), //item value
              );
            }).toList(),
          );
        });

    // Update widget
    setState(() {
      _cityController.text = selectedCity;
    });
  }

  /*
   * Retrieve data from shared
   */
  void _getUserInfoFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(prefs.getString('userData'));
    final user = Users.fromJson(userMap);
    setState(() {
      _nameController.text = user.displayName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      _genderController.text = user.gender;
      _dateOfBirthController.text = user.birthDate != null
          ? DateFormat("yyyy-MM-dd").format(DateTime.parse(user.birthDate))
          : null;
      _cityController.text = user.city;
      _addressController.text = user.fullAddress;

      /*
       * For technician pre-select expertise area
       */
      if (_isTechnician && user.expertiseArea != null) {
        List<String> expertiseArea = user.expertiseArea.split(', ');
        for (var i = 0; i < expertiseArea.length; ++i) {
          expertiseList.keys.forEach((key) {
            if (key == expertiseArea[i]) {
              expertiseList.update(key, (value) => true);
            }
          });
        }
      }
    });
  }

  /*
   * Method for get all selected Expertise Area
   */
  String _getSelectedExpertiseArea() {
    List selectedArea = new List();
    for (MapEntry<String, bool> expertise in expertiseList.entries) {
      if (expertise.value) selectedArea.add(expertise.key);
    }
    return selectedArea.join(', ');
  }

  @override
  void initState() {
    super.initState();
    _editable = widget.editable ?? false;
    _goHome = widget.goHome ?? false;
    _isTechnician = ConstantValues.userType != 'user';
    // get data from shared pref
    _getUserInfoFromShared();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: Colors.black87,
              ),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            _editable
                ? Container()
                : IconButton(
                    tooltip: 'Edit Profile',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _editable = true;
                      });
                    },
                  ),
          ],
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(fit: StackFit.loose, children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[300]),
                            image: DecorationImage(
                              image: getProfileImage(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 55.0, left: 65.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              shape: const CircleBorder(),
                              fillColor: Colors.white,
                              constraints: const BoxConstraints.tightFor(width: 30.0, height: 30.0),
                              onPressed: () => getImage(),
                              child: Icon(
                                Icons.camera_alt,
                                size: 16.0,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                    ),
                  ]),
                )
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Name',
                                  style: _textStyleMedium,
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                textCapitalization: TextCapitalization.words,
                                style: _textStyleRegular,
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Your Name",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(color: MyColor.colorBlue),
                                  ),
                                ),
                                enabled: _editable,
                                autofocus: _editable,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('Email ID', style: _textStyleMedium),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: _textStyleRegular,
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Email ID",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(color: MyColor.colorBlue),
                                  ),
                                ),
                                enabled: _editable,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('Mobile', style: _textStyleMedium),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                style: _textStyleRegular,
                                controller: _phoneController,
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(11)
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Enter Mobile Number",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(color: MyColor.colorBlue),
                                  ),
                                ),
                                enabled: _editable,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text('Gender', style: _textStyleMedium),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text('Date of Birth', style: _textStyleMedium),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: TextField(
                                readOnly: true,
                                textCapitalization: TextCapitalization.words,
                                style: _textStyleRegular,
                                controller: _genderController,
                                decoration: const InputDecoration(
                                  hintText: "Select Gender",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(color: MyColor.colorBlue),
                                  ),
                                ),
                                enabled: _editable,
                                onTap: () => _chooseGender(context),
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: TextField(
                              readOnly: true,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.datetime,
                              style: _textStyleRegular,
                              controller: _dateOfBirthController,
                              decoration: const InputDecoration(
                                hintText: "Select Date of Birth",
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: const BorderSide(color: MyColor.colorBlue),
                                ),
                              ),
                              enabled: _editable,
                              onTap: () => _selectDate(context),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'City',
                                  style: _textStyleMedium,
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: TextField(
                                  readOnly: true,
                                  textCapitalization: TextCapitalization.words,
                                  style: _textStyleRegular,
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    hintText: "Your City",
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: const BorderSide(color: MyColor.colorBlue),
                                    ),
                                  ),
                                  enabled: _editable,
                                  onTap: () async {
                                    _showCityListModal();
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('Address', style: _textStyleMedium),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                /// used to remove focus & auto scroll down
                                readOnly: !_editable,
                                textCapitalization: TextCapitalization.words,
                                style: _textStyleRegular,
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  hintText: "Write full address",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(color: MyColor.colorBlue),
                                  ),
                                ),
                                enabled: _editable,
                              ),
                            ),
                          ],
                        ),
                    ),
                    // Expertise Area
                    _isTechnician ? _getExpertiseArea() : Container(),
                    // Save Button
                    _editable ? _getActionButtons() : Container(),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  /// https://stackoverflow.com/a/48410521/5280371
  /// https://stackoverflow.com/a/58276086/5280371
  Widget _getExpertiseArea() {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Expertise Area', style: _textStyleMedium),
                  ],
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4,
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: expertiseList.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key,
                    style: GoogleFonts.ubuntu(
                        fontSize: 14, fontWeight: FontWeight.w400)),
                value: expertiseList[key],
                onChanged: (value) {
                  _editable
                      ? setState(() => expertiseList[key] = value)
                      : setState(() {});
                },
                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _getActionButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: EdgeInsets.all(14.0),
            color: MyColor.colorBlue,
            child: Text(
              "Save",
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            onPressed: () {
              setState(() {
                // Check for phone number empty or not
                if (_phoneController.text.length < 11) {
                  Util.showColorToast('Invalid phone number.', Colors.red);
                  return;
                }

                // Check for full address
                if (_addressController.text.length < 15) {
                  Util.showColorToast('Write address in details (Min 15 letter)', Colors.red);
                  return;
                }

                // Checking all validate inputs
                if (_isTechnician) {
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _genderController.text.isEmpty ||
                      _dateOfBirthController.text.isEmpty ||
                      _cityController.text.isEmpty) {
                    Util.showColorToast('All fields are required.', Colors.red);
                    return;
                  }

                  if (_getSelectedExpertiseArea().length <= 0) {
                    Util.showColorToast('You have to select at least one Expertise Area.', Colors.red);
                    return;
                  }
                }
                // Request to server for update info
                _updateAccount();
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
          ),
        ),
      ),
    );
  }

  /*
   * Upload image
   * https://stackoverflow.com/a/64297297/5280371
   */
  void _imageUpload() async {
    debugPrint('uploading image...');
    // Show progress dialog
    await _progressDialog.show();

    final request = http.MultipartRequest('POST', Uri.parse(Config.UPLOAD_PROFILE_IMAGE));
    request.headers["content-type"] = "application/json";
    request.headers["authorization"] = await auth.token;

    // add normal data
    request.fields['id'] = "${ConstantValues.userId}";
    // add image data
    request.files.add(await http.MultipartFile.fromPath('imageName', _image.path));
    // send
    final response = await request.send();
    // Hide progress dialog
    await _progressDialog.hide();

    // listen for response
    response.stream.transform(utf8.decoder).listen((body) async {
      if ( body == null || response.statusCode > 204) {
        Util.showColorToast('Error on uploading image.', Colors.red);
        return;
      }

      Map userMap = jsonDecode(body);
      var user = Users.fromJson(userMap);

      // Save user info in shared pref
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(user));

      // Save imageName to localDB & update variable imageName
      _prefs.setProfileImage(user.imageName);
      ConstantValues.imageName = user.imageName;
      Util.showColorToast('Image uploaded successfully.', Colors.green);
    });
  }

  /*
   * Update user info
   */
  Future<Null> _updateAccount() async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    String userName = ConstantValues.userName;
    Map<String, dynamic> data = new HashMap();
    data['username'] = userName;
    data['password'] = userName;
    data['phoneNumber'] = _phoneController.text;
    if (_nameController.text.isNotEmpty)
      data['displayName'] = _nameController.text;
    if (_emailController.text.isNotEmpty) data['email'] = _emailController.text;
    if (_genderController.text.isNotEmpty)
      data['gender'] = _genderController.text;
    if (_dateOfBirthController.text.isNotEmpty)
      data['birthDate'] = Utilities.formatToServerDateTime(
          _dateOfBirthController.text + 'T12:00:00Z'); // server date format "1993-03-11T12:00:00Z"
    if (_cityController.text.isNotEmpty) data['city'] = _cityController.text;
    if (_addressController.text.isNotEmpty)
      data['fullAddress'] = _addressController.text;
    if (_isTechnician) data['expertiseArea'] = _getSelectedExpertiseArea();

    //encode Map to JSON
    var body = json.encode(data);

    var url = Uri.encodeFull(Config.UPDATE_USER_INFO + '${ConstantValues.userId}');
    final response = await http.put(url, headers: headers, body: body);
    // Hide progress dialog
    await _progressDialog.hide();

    Http.printResponse(response);
    if (response.statusCode > 204 || response.body == null) {
      Util.showColorToast('Something went wrong. Please try again.', Colors.red);
      return;
    }

    Map userMap = jsonDecode(response.body);
    var user = Users.fromJson(userMap);

    // Save user info in shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));

    // Disable edit & hide button
    setState(() {
      _editable = false;
      FocusScope.of(context).requestFocus(FocusNode());
    });

    /*
     * redirect to dashboard for first time profile setup complete
     */
    if (_goHome) _gotoDashboard();
  }

  /*
   * Method for redirect user to dashboard
   */
  _gotoDashboard() {
    // Save login session
    _prefs.setUserLoggedIn(true);
    ConstantValues.isUserLogin = true;

    // Redirect to Home Screen
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);
  }

  ImageProvider getProfileImage() {
   if (_image != null){
     print(_image);
      return FileImage(_image);
    } else if (_imageName != null){
     log(Config.PROFILE_IMAGE_URL + _imageName);
      return NetworkImage(Config.PROFILE_IMAGE_URL + _imageName);
    } else {
     print('default image');
      return ExactAssetImage('assets/images/avatar.png');
    }
  }
}
