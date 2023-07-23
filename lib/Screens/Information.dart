import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../utils/sharedpref.dart';

class InformationPage extends StatefulWidget {
  // String phone = "";
  const InformationPage({Key? key}) : super(key: key);

  @override
  _InformationPage createState() => _InformationPage();
}

class _InformationPage extends State<InformationPage> {
  late String phone = "";
  var latitude = "Getting latitude".obs;
  var longitude = "Getting longitude".obs;
  late StreamSubscription<Position> streamSubscription;
  String datetime = DateTime.now().toString();
  int _activeStepIndex = 0;
  bool _validateName = false;
  bool _validateHouse = false;
  bool _validateStreet = false;
  bool _validateCity = false;
  bool _validateState = false;
  bool _validatePincode = false;
  TextEditingController name = TextEditingController();
  TextEditingController houseInfo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getlocation();
    fetchPhone();
  }

  fetchPhone() async {
    phone = await SharedPrefUtils.readPrefStr('phone');
  }

  getlocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // return await Geolocator.getCurrentPosition();
    // streamSubscription =
    //     Geolocator.getPositionStream().listen((Position position) {
    //   latitude.value = '${position.latitude}';
    //   longitude.value = '${position.longitude}';
    // });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude.value = '${position.latitude}';
    longitude.value = '${position.longitude}';
  }

  Future<void> insertRecord() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude.value = '${position.latitude}';
    longitude.value = '${position.longitude}';
    // getlocation();
    if (name.text != "" &&
        houseInfo.text != "" &&
        street.text != "" &&
        city.text != "" &&
        state.text != "" &&
        pincode.text != "" &&
        latitude.value != "" &&
        longitude.value != "") {
      String url = "https://mytiffiny.000webhostapp.com/insert_Record.php";
      var res = await http.post(Uri.parse(url), body: {
        "name": name.text,
        "phone": phone,
        "houseInfo": houseInfo.text,
        "date": datetime,
        "street": street.text,
        "city": city.text,
        "state": state.text,
        "pincode": pincode.text,
        "latitude": latitude.toString(),
        "longitude": longitude.toString()
      });
      print(res.statusCode);
      // var response = await json.decode(res.body);
      // if (response["success"] == "true") {
      //   print("Record Inserted")s;
      // } else {
      //   print("Some Issues");
      // }
      print(houseInfo.text);
      print(street.text);
      print(city.text);
      print(state.text);
      print(pincode.text);
      print(latitude.toString());
      print(longitude.toString());
    }
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Name'),
          content: Container(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: phone,
                    errorText: _validateName ? 'Value Can\'t Be Empty' : null,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text('Address'),
            content: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: houseInfo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'House Number and Name',
                      errorText:
                          _validateHouse ? 'Value Can\'t Be Empty' : null,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: street,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Street',
                      errorText:
                          _validateStreet ? 'Value Can\'t Be Empty' : null,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: city,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                      errorText: _validateCity ? 'Value Can\'t Be Empty' : null,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: state,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'State',
                      errorText:
                          _validateState ? 'Value Can\'t Be Empty' : null,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: pincode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pin Code',
                      errorText:
                          _validatePincode ? 'Value Can\'t Be Empty' : null,
                    ),
                  ),
                ],
              ),
            )),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        backgroundColor: Colors.amber,
      ),
      body: Stepper(
          type: StepperType.horizontal,
          currentStep: _activeStepIndex,
          steps: stepList(),
          onStepContinue: () {
            if (_activeStepIndex == 0) {
              setState(() {
                if (name.text.isEmpty) {
                  _validateName = true;
                } else {
                  _validateName = false;
                }
              });
              if (_validateName == false) {
                if (_activeStepIndex == 0) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                }
              } else {
                null;
              }
            } else {
              setState(() {
                houseInfo.text.isEmpty
                    ? _validateHouse = true
                    : _validateHouse = false;
                street.text.isEmpty
                    ? _validateStreet = true
                    : _validateStreet = false;
                city.text.isEmpty
                    ? _validateCity = true
                    : _validateCity = false;
                state.text.isEmpty
                    ? _validateState = true
                    : _validateState = false;
                pincode.text.isEmpty
                    ? _validatePincode = true
                    : _validatePincode = false;
              });
              if (_validateHouse == false &&
                  _validateStreet == false &&
                  _validateCity == false &&
                  _validateState == false &&
                  _validatePincode == false) {
                if (_activeStepIndex <= 1) {
                  setState(() {
                    _activeStepIndex += 1;
                  });
                  // if (_activeStepIndex == 2) {
                  //   insertRecord();
                  //   Navigator.pushNamed(context, 'home');
                  // }
                }
              } else {
                null;
              }
            }
          },
          onStepCancel: () {
            if (_activeStepIndex == 0) {
              return;
            }

            setState(() {
              _activeStepIndex -= 1;
            });
          },
          onStepTapped: (int index) {
            setState(() {
              _activeStepIndex = index;
            });
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _activeStepIndex == 0
                      ? ElevatedButton(
                          // onPressed: () async {
                          //   await getlocation();
                          //   details.onStepContinue;
                          // },
                          onPressed: details.onStepContinue,
                          child: const Text('Next'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            insertRecord();
                            // Navigator.pushNamed(context, 'home');
                          },
                          child: const Text('Submit'),
                        ),
                  const SizedBox(width: 10),
                  _activeStepIndex == 1
                      ? OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        )
                      : Container(),
                ],
              ),
            );
          }),
    );
  }
}
