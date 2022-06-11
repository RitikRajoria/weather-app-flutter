import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../services/data_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();

  final _dataService = DataService();

  final currDate = DateTime.now();
  String? currentDate;

  WeatherResponse? _response;

  List<int> indexes = [];
  List<int> todaysDataIndexes = [];

  List<String> dates = [];
  List<String> todaysData = [];

  String? formattedDate;
  bool tfFocus = false;

  // 0 => search city name, 1=> got data, 2=> wrong city name, 3=> server error, 4 => CircularprogressIndicator
  int uiChanger = 4;

  bool firstTime = false;

  var yourCity = "";

  SnackBar snackBar = SnackBar(
    content: Text('Remove extra spaces!'),
  );

  @override
  void initState() {
    super.initState();

    _determinePosition().then((value) {
      _getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        tfFocus = false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _determinePosition();
                  _getLocation();
                },
                icon: Icon(Icons.gps_fixed_rounded),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tfFocus = !tfFocus;
                      });
                    },
                    child: Container(
                      // color: Colors.red,
                      width: (size.width) * 0.65,
                      child: tfFocus
                          ? TextField(
                              autofocus: true,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              cursorColor: Colors.white,
                              controller: searchText,
                              decoration: InputDecoration(
                                hintText: 'Enter City Name',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade300, fontSize: 20),
                                border: InputBorder.none,
                              ),
                            )
                          : Text(
                              'Search City',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (searchText.text[0] != " ") {
                        if (searchText.text.isNotEmpty) {
                          _search(searchText.text.trim());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: Icon(Icons.search_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: uiChanger == 4
                  ? Column(
                      children: [
                        SizedBox(
                          height: (size.height) * 0.45,
                        ),
                        CircularProgressIndicator(
                            color: Colors.blueGrey.shade600),
                      ],
                    )
                  : firstTime
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: (size.height) * 0.45,
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: Colors.blueGrey.shade600,
                                )),
                          ],
                        )
                      : uiChanger == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: (size.height) * 0.45,
                                ),
                                Text("Can't able to detect your Loacation."),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Try Searching For City!!"),
                              ],
                            )
                          : uiChanger == 1
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // city heading
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10, top: 20),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: (size.width) * 0.58,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${_response!.city!.name}',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 1.4),
                                                  ),

                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  //temp and weather type
                                                  Container(
                                                    child: Text(
                                                      '${_response!.list![0].main!.temp!.toStringAsFixed(1)}° C',
                                                      style: TextStyle(
                                                        fontSize: 60,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 14,
                                                        right: 14,
                                                        top: 6,
                                                        bottom: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueGrey.shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      "${_response!.list![0].weather![0].main}",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        letterSpacing: 1.2,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),

                                                  // temp and weather type
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: (size.width) * 0.34,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(70),
                                                color: Colors.blueGrey.shade100,
                                              ),
                                              child: Image.asset(
                                                "assets/images/weather_icons/${_response!.list![0].weather![0].icon}.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //city heading end

                                    const SizedBox(
                                      height: 22,
                                    ),

                                    //humidity, wind speed and pressure
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.water_drop_outlined,
                                                    size: 20),
                                                Text(
                                                  " ${_response!.list![0].main!.humidity}%",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.arrow_circle_down,
                                                    size: 20),
                                                Text(
                                                  " ${_response!.list![0].main!.pressure} mBar",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.air, size: 20),
                                                Text(
                                                  " ${_response!.list![0].wind!.speed} m/s",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //humidity, wind speed and pressure end

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18, top: 22),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Today",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.4,
                                            color: Colors.blueGrey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    //Today's weather data

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Container(
                                        height: (size.height) * 0.15,
                                        width: double.infinity,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: todaysData.length,
                                            itemBuilder: (context, index) {
                                              String? iconsId = _response!
                                                  .list![
                                                      todaysDataIndexes[index]]
                                                  .weather![0]
                                                  .icon;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3, right: 3),
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .blueGrey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  width: (size.width) * 0.25,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${todaysData[index]}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                          height: 44,
                                                          width: 44,
                                                          child: Image.asset(
                                                              "assets/images/weather_icons/${iconsId}.png")),
                                                      Text(
                                                        "${_response!.list![todaysDataIndexes[index]].main!.temp!.toStringAsFixed(1)}° C",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),

                                    //Today's weather data end
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //5 - day forecast

                                    Container(
                                      height: (size.height) * 0.56,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: indexes.length,
                                          itemBuilder: (context, index) {
                                            String? iconsId = _response!
                                                .list![indexes[index]]
                                                .weather![0]
                                                .icon;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 20,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .blueGrey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      width: (size.width) * 0.4,
                                                      child: Text(
                                                        "${dates[index]}",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 35,
                                                      height: 35,
                                                      child: Image.asset(
                                                          "assets/images/weather_icons/${iconsId}.png"),
                                                    ),
                                                    Container(
                                                      width: (size.width) * 0.3,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${_response!.list![indexes[index]].main!.temp!.toStringAsFixed(1)}° C ",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              : uiChanger == 2
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: (size.height) * 0.45,
                                        ),
                                        Text(
                                            "Can't find the City your'e looking for."),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            "Try Searching with different keywords or check for spelling!"),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: (size.height) * 0.45,
                                        ),
                                        Text(
                                            'Internal Server Error, Try Again!'),
                                      ],
                                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _search(String searchText) async {
    _response = null;
    firstTime = true;

    final response = await _dataService.getWeather(searchText);
    firstTime = false;

    indexes = [];
    dates = [];
    todaysDataIndexes = [];
    todaysData = [];
    DateTime date;
    _response = response;
    currentDate = DateFormat('yyyy-MM-dd').format(currDate);

    print("current $currentDate");
    setState(() {
      if (_response!.cod == "200") {
        uiChanger = 1;
      } else if (_response!.cod == "404") {
        uiChanger = 2;
      } else {
        print("unknown error occured");
        uiChanger = 3;
      }
    });
    setState(() {
      _response = response;

      for (int i = 0; i < _response!.list!.length; i++) {
        if (_response!.list![i].dtTxt!.contains('12:00:00')) {
          indexes.add(i);
          date = DateTime.parse('${_response!.list![i].dtTxt}');
          formattedDate = DateFormat('EEEEEEEE').format(date);
          dates.add(formattedDate!);
        }
      }
      for (int i = 0; i < _response!.list!.length; i++) {
        if (_response!.list![i].dtTxt!.contains(currentDate!)) {
          todaysDataIndexes.add(i);
          date = DateTime.parse('${_response!.list![i].dtTxt}');
          formattedDate = DateFormat('hh a').format(date);
          todaysData.add(formattedDate!);
        }
      }
    });
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> pm =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      yourCity = pm[0].locality.toString();
    });
    _search(yourCity);
    searchText.clear();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        uiChanger = 0;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          uiChanger = 0;
        });

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
